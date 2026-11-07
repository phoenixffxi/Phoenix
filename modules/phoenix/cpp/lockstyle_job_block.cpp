/************************************************************************
 * Lockstyle Job Block
 *
 * Disallows players from lockstyling gear they cannot currently equip.
 ************************************************************************/
#include "map/entities/char_entity.h"
#include "map/items/item_equipment.h"
#include "map/packets/basic.h"
#include "map/packets/c2s/0x053_lockstyle.h"
#include "map/packets/s2c/0x11c_lockstyle_error.h"
#include "map/utils/itemutils.h"
#include "map/utils/moduleutils.h"

#include <vector>

namespace
{

class LockstyleJobBlock : public CPPModule
{
    void OnInit() override
    {
    }

    auto OnIncomingPacket(MapSession* PSession, CCharEntity* PChar, CBasicPacket& data) -> bool override
    {
        // Return if the packet isn't lockstyle
        if (data.getType() != static_cast<uint16>(GP_CLI_COMMAND_LOCKSTYLE::packetId))
        {
            return false;
        }

        auto* packet = data.as<GP_CLI_COMMAND_LOCKSTYLE>();
        if (static_cast<GP_CLI_COMMAND_LOCKSTYLE_MODE>(packet->Mode) != GP_CLI_COMMAND_LOCKSTYLE_MODE::Set)
        {
            return false;
        }

        const uint8 mainJob    = static_cast<uint8>(PChar->GetMJob());
        const uint8 equipLevel = PChar->GetMLevel();

        // Iterate over player's intended equipment to be lockstyled and check if they are valid
        std::vector<uint16_t> blockedItemIds;
        for (uint8 i = 0; i < packet->Count; ++i)
        {
            auto& item = packet->Items[i];

            if (item.ItemNo == 0 || item.EquipKind > SLOT_FEET)
            {
                continue;
            }

            const auto* PItem = xi::items::lookup<CItemEquipment>(item.ItemNo);
            if (!PItem)
            {
                continue;
            }

            // Check if the item is equippable by the player's main job, and level
            if (!(PItem->getJobs() & (1 << (mainJob - 1))) || PItem->getReqLvl() > equipLevel)
            {
                blockedItemIds.push_back(item.ItemNo);
                item.ItemNo = 0;
            }
        }

        if (!blockedItemIds.empty())
        {
            PChar->pushPacket<GP_SERV_COMMAND_LOCKSTYLE_ERROR>(blockedItemIds);
        }

        // Let the base handler process the sanitized set
        return false;
    }
};

} // namespace

REGISTER_CPP_MODULE(LockstyleJobBlock);
