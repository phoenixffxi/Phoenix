/*
 * Forward-only item and monster event feed for Phoenix Platform.
 * The map loop only queues events; a worker sends batches to the local box agent.
 */

#include "map/ai/ai_container.h"
#include "map/entities/char_entity.h"
#include "map/entities/mob_entity.h"
#include "map/enums/packet_s2c.h"
#include "map/item_container.h"
#include "map/items/item.h"
#include "map/packets/basic.h"
#include "map/packets/s2c/0x01e_item_num.h"
#include "map/packets/s2c/0x020_item_attr.h"
#include "map/utils/moduleutils.h"
#include "map/utils/zoneutils.h"
#include "map/zone.h"
#include "map/zone_entities.h"

#include "common/logging.h"

#include <fmt/chrono.h>
#include <httplib.h>
#include <nlohmann/json.hpp>

#include <atomic>
#include <chrono>
#include <condition_variable>
#include <cstdlib>
#include <deque>
#include <map>
#include <mutex>
#include <random>
#include <string>
#include <thread>
#include <unordered_map>
#include <utility>

namespace
{

constexpr size_t MaxPendingEvents = 20'000;

auto utcNow() -> std::string
{
    const auto now = std::chrono::system_clock::now();
    return fmt::format("{:%Y-%m-%dT%H:%M:%SZ}", fmt::gmtime(std::chrono::system_clock::to_time_t(now)));
}

} // namespace

class WorldEventsModule : public CPPModule
{
public:
    ~WorldEventsModule() override
    {
        {
            std::lock_guard lock(mutex_);
            stopping_ = true;
        }
        ready_.notify_one();
        if (worker_.joinable())
            worker_.join();
    }

    void OnInit() override
    {
        const char* url         = std::getenv("WORLD_EVENTS_AGENT_URL");
        const char* key         = std::getenv("WORLD_EVENTS_AGENT_KEY");
        const char* environment = std::getenv("WORLD_EVENTS_ENV");
        if (!url || !key || !environment)
            return;

        agentUrl_    = url;
        agentKey_    = key;
        environment_ = environment;
        if ((environment_ != "beta" && environment_ != "prod") ||
            !agentUrl_.starts_with("http://127.0.0.1:"))
        {
            ShowError("World events require a beta/prod environment and a loopback agent URL");
            return;
        }

        std::random_device random;
        processTag_ = fmt::format("{:08x}{:08x}{:08x}{:08x}", random(), random(), random(), random());
        enabled_    = true;
        worker_     = std::thread([this]()
                                  {
                                  sendLoop();
                                  });

        lua.set_function("__phoenixWorldSpawn", [this](uint32 id)
                         {
                             onMobSpawn(id);
                         });
        lua.set_function("__phoenixWorldKill", [this](uint32 id)
                         {
                             onMobKill(id);
                         });
        lua.set_function("__phoenixWorldDrop", [this](uint32 id, uint16 itemId)
                         {
                             onMobDrop(id, itemId);
                         });
        spawnListener_ = lua.safe_script("return function(mob) __phoenixWorldSpawn(mob:getID()) end");
        killListener_  = lua.safe_script("return function(mob) __phoenixWorldKill(mob:getID()) end");
        dropListener_  = lua.safe_script("return function(mob, _, itemId) __phoenixWorldDrop(mob:getID(), itemId) end");

        zoneutils::ForEachZone([this](CZone* zone)
                               {
                                   attachZone(zone);
                               });
    }

    void OnZoneTick(CZone* zone) override
    {
        if (!enabled_)
            return;
        attachZone(zone);
    }

    void OnCharZoneIn(CCharEntity* PChar) override
    {
        if (!enabled_)
            return;
        snapshotInventory(PChar);
    }

    void OnCharZoneOut(CCharEntity* PChar) override
    {
        if (!enabled_)
            return;
        flushItemDeltas(PChar->id);
        inventory_.erase(PChar->id);
    }

    void OnTimeServerTick() override
    {
        if (!enabled_)
            return;
        flushItemDeltas(0);
    }

    void OnPushPacket(CCharEntity* PChar, const std::unique_ptr<CBasicPacket>& packet) override
    {
        if (!enabled_ || !PChar || !packet || !inventory_.contains(PChar->id))
            return;

        uint8 location = 0;
        uint8 slot     = 0;
        if (packet->getType() == std::to_underlying(PacketS2C::GP_SERV_COMMAND_ITEM_NUM))
        {
            const auto& data = packet->ref<GP_SERV_COMMAND_ITEM_NUM::PacketData>(sizeof(GP_SERV_HEADER));
            location         = data.Category;
            slot             = data.ItemIndex;
        }
        else if (packet->getType() == std::to_underlying(PacketS2C::GP_SERV_COMMAND_ITEM_ATTR))
        {
            const auto& data = packet->ref<GP_SERV_COMMAND_ITEM_ATTR::PacketData>(sizeof(GP_SERV_HEADER));
            location         = data.Category;
            slot             = data.ItemIndex;
        }
        else
        {
            return;
        }

        if (location >= MAX_CONTAINER_ID || slot > MAX_CONTAINER_SIZE)
            return;
        const auto* storage = PChar->getStorage(location);
        if (!storage)
            return;

        const auto*     item     = storage->GetItem(slot);
        const SlotState current  = item && item->getID() != 0xFFFF ? SlotState{ item->getID(), item->getQuantity() } : SlotState{};
        const auto      key      = static_cast<uint16>((location << 8) | slot);
        auto&           slots    = inventory_.at(PChar->id);
        const auto      previous = slots.contains(key) ? slots.at(key) : SlotState{};

        if (previous.itemId == current.itemId)
        {
            if (current.itemId && previous.quantity != current.quantity)
                itemDeltas_[{ PChar->id, current.itemId }] += static_cast<int64>(current.quantity) - previous.quantity;
        }
        else
        {
            if (previous.itemId)
                itemDeltas_[{ PChar->id, previous.itemId }] -= previous.quantity;
            if (current.itemId)
                itemDeltas_[{ PChar->id, current.itemId }] += current.quantity;
        }

        if (current.itemId)
            slots[key] = current;
        else
            slots.erase(key);
    }

private:
    struct SlotState
    {
        uint16 itemId   = 0;
        uint32 quantity = 0;
    };

    void attachZone(CZone* zone)
    {
        if (!zone || !zone->GetZoneEntities())
            return;
        for (const auto& [_, entity] : zone->GetZoneEntities()->GetMobList())
        {
            auto* mob = static_cast<CMobEntity*>(entity);
            if (!mob || !mob->PAI || attachedMobs_[mob->id] == mob)
                continue;
            attachedMobs_[mob->id] = mob;
            mob->PAI->EventHandler.addListener("SPAWN", spawnListener_, "PXI_WORLD_SPAWN");
            mob->PAI->EventHandler.addListener("DEATH", killListener_, "PXI_WORLD_KILL");
            mob->PAI->EventHandler.addListener("TREASUREPOOL", dropListener_, "PXI_WORLD_DROP");
        }
    }

    void snapshotInventory(CCharEntity* PChar)
    {
        auto& slots = inventory_[PChar->id];
        slots.clear();
        for (uint8 location = 0; location < MAX_CONTAINER_ID; ++location)
        {
            const auto* storage = PChar->getStorage(location);
            if (!storage)
                continue;
            for (uint16 slot = 0; slot <= storage->GetSize(); ++slot)
            {
                const auto* item = storage->GetItem(static_cast<uint8>(slot));
                if (item && item->getID() != 0xFFFF)
                    slots[static_cast<uint16>((location << 8) | slot)] = { item->getID(), item->getQuantity() };
            }
        }
    }

    void flushItemDeltas(uint32 charId)
    {
        for (auto it = itemDeltas_.begin(); it != itemDeltas_.end();)
        {
            if (charId && it->first.first != charId)
            {
                ++it;
                continue;
            }
            if (it->second > 0)
                enqueue({ { "type", "item_acquired" }, { "characterId", it->first.first }, { "itemId", it->first.second }, { "quantity", it->second } });
            it = itemDeltas_.erase(it);
        }
    }

    void onMobSpawn(uint32 mobId)
    {
        {
            std::lock_guard lock(mutex_);
            killIds_.erase(mobId);
        }
        enqueue({ { "type", "mob_spawn" }, { "monsterId", mobId } });
    }

    void onMobKill(uint32 mobId)
    {
        const auto id = nextId();
        {
            std::lock_guard lock(mutex_);
            killIds_[mobId] = id;
        }
        enqueue({ { "id", id }, { "type", "mob_kill" }, { "monsterId", mobId } });
    }

    void onMobDrop(uint32 mobId, uint16 itemId)
    {
        std::string killId;
        {
            std::lock_guard lock(mutex_);
            const auto      kill = killIds_.find(mobId);
            if (kill == killIds_.end())
                return;
            killId = kill->second;
        }
        enqueue({ { "type", "mob_drop" }, { "monsterId", mobId }, { "itemId", itemId }, { "quantity", 1 }, { "killId", killId } });
    }

    auto nextId() -> std::string
    {
        return fmt::format("{}-{}", processTag_, sequence_.fetch_add(1, std::memory_order_relaxed));
    }

    void enqueue(nlohmann::json event)
    {
        if (!event.contains("id"))
            event["id"] = nextId();
        event["environment"] = environment_;
        event["occurredAt"]  = utcNow();
        bool queued          = false;
        {
            std::lock_guard lock(mutex_);
            if (pending_.size() < MaxPendingEvents)
            {
                pending_.push_back(std::move(event));
                queued = true;
            }
            else
            {
                dropped_.fetch_add(1, std::memory_order_relaxed);
            }
        }
        if (queued)
            ready_.notify_one();
    }

    void sendLoop()
    {
        httplib::Client client(agentUrl_);
        client.set_connection_timeout(2, 0);
        client.set_read_timeout(5, 0);
        auto lastDropWarning = std::chrono::steady_clock::now() - std::chrono::seconds(30);

        while (true)
        {
            const auto now = std::chrono::steady_clock::now();
            if (now - lastDropWarning >= std::chrono::seconds(30))
            {
                const auto lost = dropped_.exchange(0, std::memory_order_relaxed);
                if (lost)
                    ShowWarningFmt("World event queue full; discarded {} events", lost);
                lastDropWarning = now;
            }
            nlohmann::json batch = nlohmann::json::array();
            {
                std::unique_lock lock(mutex_);
                ready_.wait_for(lock, std::chrono::seconds(1), [this]()
                                {
                                    return stopping_ || !pending_.empty();
                                });
                if (stopping_)
                    break;
                for (size_t i = 0; i < pending_.size() && i < 100; ++i)
                    batch.push_back(pending_[i]);
            }
            if (batch.empty())
                continue;

            const auto result = client.Post("/world-events", { { "X-API-Key", agentKey_ } }, nlohmann::json({ { "events", batch } }).dump(), "application/json");
            if (!result || result->status < 200 || result->status >= 300)
            {
                std::this_thread::sleep_for(std::chrono::seconds(2));
                continue;
            }

            {
                std::lock_guard lock(mutex_);
                for (size_t i = 0; i < batch.size() && !pending_.empty(); ++i)
                    pending_.pop_front();
            }
            if (batch.size() == 100)
                std::this_thread::sleep_for(std::chrono::milliseconds(250));
        }
    }

    bool                                                              enabled_  = false;
    bool                                                              stopping_ = false;
    std::string                                                       processTag_;
    std::atomic<uint64>                                               sequence_{ 0 };
    std::atomic<uint64>                                               dropped_{ 0 };
    std::string                                                       agentUrl_;
    std::string                                                       agentKey_;
    std::string                                                       environment_;
    sol::function                                                     spawnListener_;
    sol::function                                                     killListener_;
    sol::function                                                     dropListener_;
    std::unordered_map<uint32, CMobEntity*>                           attachedMobs_;
    std::unordered_map<uint32, std::unordered_map<uint16, SlotState>> inventory_;
    std::map<std::pair<uint32, uint16>, int64>                        itemDeltas_;
    std::unordered_map<uint32, std::string>                           killIds_;
    std::deque<nlohmann::json>                                        pending_;
    std::mutex                                                        mutex_;
    std::condition_variable                                           ready_;
    std::thread                                                       worker_;
};

REGISTER_CPP_MODULE(WorldEventsModule);
