/*
===========================================================================

  Copyright (c) 2025 LandSandBoat Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see http://www.gnu.org/licenses/

===========================================================================
*/

#include "0x0ac_guild_sell.h"

#include "common/database.h"
#include "common/settings.h"
#include "entities/char_entity.h"
#include "items/item_shop.h"
#include "lua/luautils.h"
#include "packets/s2c/0x01d_item_same.h"
#include "packets/s2c/0x084_guild_sell.h"
#include "utils/charutils.h"
#include "utils/itemutils.h"
#include "utils/zoneutils.h"

namespace
{

const auto auditSale = [](Scheduler& scheduler, CCharEntity* PChar, uint32_t itemId, uint32_t basePrice, uint8_t quantity)
{
    if (settings::get<bool>("map.AUDIT_PLAYER_VENDOR"))
    {
        scheduler.postToWorkerThread(
            [itemId, quantity, seller = PChar->id, sellerName = PChar->getName(), basePrice]()
            {
                auto totalPrice = basePrice * quantity;

                const auto query = "INSERT INTO audit_vendor(itemid, quantity, seller, seller_name, baseprice, totalprice, date) VALUES (?, ?, ?, ?, ?, ?, UNIX_TIMESTAMP())";
                if (!db::preparedStmt(query, itemId, quantity, seller, sellerName, basePrice, totalPrice))
                {
                    ShowErrorFmt("Failed to log vendor sale (item: {}, quantity: {}, seller: {}, baseprice: {}, totalprice: {})",
                                 itemId,
                                 quantity,
                                 seller,
                                 basePrice,
                                 totalPrice);
                }
            });
    }
};

} // namespace

auto GP_CLI_COMMAND_GUILD_SELL::validate(MapSession* PSession, const CCharEntity* PChar) const -> PacketValidationResult
{
    return PacketValidator(PChar)
        .blockedBy({ BlockedState::InEvent, BlockedState::Crafting })
        .custom([&](PacketValidator& v)
                {
                    if (PChar->PGuildShop == nullptr && PChar->guildShopNpc_.id == 0)
                    {
                        v.mustNotEqual(PChar->PGuildShop, nullptr, "Character does not have a guild shop");
                    }
                })
        .range("ItemNum", this->ItemNum, 1, 99);
}

void GP_CLI_COMMAND_GUILD_SELL::process(MapSession* PSession, CCharEntity* PChar) const
{
    const CItem* PItem = xi::items::lookup(this->ItemNo);
    if (!PItem)
    {
        ShowWarning("User '%s' attempting to sell an invalid item to guild vendor!", PChar->getName());
        return;
    }

    // A guild shop never buys more than a single stack of an item per transaction.
    if (this->ItemNum > PItem->getStackSize())
    {
        PChar->pushPacket<GP_SERV_COMMAND_GUILD_SELL>(PChar, 0, 0, static_cast<uint8>(-4));
        return;
    }

    if (PChar->guildShopNpc_.id != 0)
    {
        if (auto* PNpc = zoneutils::GetEntity(PChar->guildShopNpc_.id, TYPE_NPC))
        {
            const auto result = luautils::callGlobal<sol::table>("xi.guildShops.onPlayerSell", PChar, PNpc, this->ItemNo, this->ItemNum);
            if (result.valid())
            {
                const auto itemNo = result.get_or("itemNo", uint16{ 0 });
                const auto count  = result.get_or("count", uint8{ 0 });
                const auto trade  = result.get_or("trade", int32{ 0 });
                const auto sold   = result.get_or("sold", uint8{ 0 });
                const auto price  = result.get_or("price", uint32{ 0 });
                PChar->pushPacket<GP_SERV_COMMAND_GUILD_SELL>(PChar, count, itemNo, static_cast<uint8>(trade));

                if (sold > 0)
                {
                    auditSale(*PSession->scheduler, PChar, itemNo, price, sold);
                }
            }
        }

        return;
    }

    uint8       quantity   = this->ItemNum;
    const uint8 shopSlotId = PChar->PGuildShop->SearchItem(this->ItemNo);

    if (shopSlotId == ERROR_SLOTID)
    {
        return;
    }

    auto*        shopItem  = static_cast<CItemShop*>(PChar->PGuildShop->GetItem(shopSlotId));
    const CItem* charItem  = PChar->getStorage(LOC_INVENTORY)->GetItem(this->PropertyItemIndex);
    const uint32 basePrice = shopItem->getBasePrice();

    if (!charItem || charItem->getID() != shopItem->getID())
    {
        ShowWarning("User '%s' attempting to sell an invalid item to guild vendor!", PChar->getName());
        return;
    }

    if (PChar->PGuildShop->GetItem(shopSlotId)->getQuantity() + quantity > PChar->PGuildShop->GetItem(shopSlotId)->getStackSize())
    {
        quantity = PChar->PGuildShop->GetItem(shopSlotId)->getStackSize() - PChar->PGuildShop->GetItem(shopSlotId)->getQuantity();
    }

    // TODO: add all sellable items to guild table
    if (quantity != 0 && charItem->getQuantity() >= quantity)
    {
        if (charutils::UpdateItem(PChar, LOC_INVENTORY, this->PropertyItemIndex, -quantity) == this->ItemNo)
        {
            // TODO: Don't pass around Scheduler& through PSession
            auditSale(*PSession->scheduler, PChar, charItem->getID(), basePrice, quantity);

            charutils::UpdateItem(PChar, LOC_INVENTORY, 0, shopItem->getSellPrice() * quantity);
            ShowInfo("GP_CLI_COMMAND_GUILD_SELL: Player '%s' sold %u of ItemNo %u [to GUILD] ", PChar->getName(), quantity, this->ItemNo);
            PChar->PGuildShop->GetItem(shopSlotId)->setQuantity(PChar->PGuildShop->GetItem(shopSlotId)->getQuantity() + quantity);
            PChar->pushPacket<GP_SERV_COMMAND_GUILD_SELL>(
                PChar, PChar->PGuildShop->GetItem(PChar->PGuildShop->SearchItem(this->ItemNo))->getQuantity(), this->ItemNo, quantity);
            PChar->pushPacket<GP_SERV_COMMAND_ITEM_SAME>(PChar);
        }
    }
    // TODO: error messages!
}
