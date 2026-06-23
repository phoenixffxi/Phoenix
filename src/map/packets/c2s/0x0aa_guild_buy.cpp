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

#include "0x0aa_guild_buy.h"

#include "entities/char_entity.h"
#include "items/item.h"
#include "items/item_shop.h"
#include "lua/luautils.h"
#include "packets/s2c/0x01d_item_same.h"
#include "packets/s2c/0x082_guild_buy.h"
#include "utils/charutils.h"
#include "utils/itemutils.h"
#include "utils/zoneutils.h"

auto GP_CLI_COMMAND_GUILD_BUY::validate(MapSession* PSession, const CCharEntity* PChar) const -> PacketValidationResult
{
    return PacketValidator(PChar)
        .blockedBy({ BlockedState::InEvent })
        .custom([&](PacketValidator& v)
                {
                    if (PChar->PGuildShop == nullptr && PChar->guildShopNpc_.id == 0)
                    {
                        v.mustNotEqual(PChar->PGuildShop, nullptr, "Character does not have a guild shop");
                    }
                })
        .range("ItemNum", this->ItemNum, 1, 99)
        .mustEqual(this->PropertyItemIndex, 0, "PropertyItemIndex not 0");
}

void GP_CLI_COMMAND_GUILD_BUY::process(MapSession* PSession, CCharEntity* PChar) const
{
    uint8        quantity = this->ItemNum;
    const CItem* PItem    = xi::items::lookup(this->ItemNo);
    if (!PItem)
    {
        ShowWarning("User '%s' attempting to buy an invalid item from guild vendor!", PChar->getName());
        return;
    }

    // You can't buy more than a stack at once; retail turns this away instead of quietly clamping it.
    if (quantity > PItem->getStackSize())
    {
        PChar->pushPacket<GP_SERV_COMMAND_GUILD_BUY>(PChar, 0, 0, static_cast<uint8>(-1));
        return;
    }

    if (PChar->guildShopNpc_.id != 0)
    {
        if (auto* PNpc = zoneutils::GetEntity(PChar->guildShopNpc_.id, TYPE_NPC))
        {
            // onPlayerBuy returns { itemNo, count, trade }; serialize it into the 0x082 result
            // (a rejection is { 0, 0, -1 }).
            const auto result = luautils::callGlobal<sol::table>("xi.guildShops.onPlayerBuy", PChar, PNpc, this->ItemNo, quantity);
            if (result.valid())
            {
                const auto itemNo = result.get_or("itemNo", uint16{ 0 });
                const auto count  = result.get_or("count", uint8{ 0 });
                const auto trade  = result.get_or("trade", int32{ 0 });
                PChar->pushPacket<GP_SERV_COMMAND_GUILD_BUY>(PChar, count, itemNo, static_cast<uint8>(trade));
            }
        }

        return;
    }

    // Handle legacy guild shops
    const uint8 shopSlotId = PChar->PGuildShop->SearchItem(this->ItemNo);

    if (shopSlotId == ERROR_SLOTID)
    {
        ShowWarning("User '%s' attempting to buy an item not in guild vendor: %u", PChar->getName(), this->ItemNo);
        return;
    }

    const auto   item = static_cast<CItemShop*>(PChar->PGuildShop->GetItem(shopSlotId));
    const CItem* gil  = PChar->getStorage(LOC_INVENTORY)->GetItem(0);

    if (!gil || !gil->isType(ITEM_CURRENCY) || gil->getReserve() != 0 || !item)
    {
        return;
    }

    if (item->getQuantity() >= quantity)
    {
        if (gil->getQuantity() > (item->getBasePrice() * quantity))
        {
            if (charutils::AddItem(PChar, LOC_INVENTORY, this->ItemNo, quantity) != ERROR_SLOTID)
            {
                charutils::UpdateItem(PChar, LOC_INVENTORY, 0, -static_cast<int32>(item->getBasePrice() * quantity));
                ShowInfo("GP_CLI_COMMAND_GUILD_BUY: Player '%s' purchased %u of itemID %u [from GUILD] ", PChar->getName(), quantity, this->ItemNo);
                PChar->PGuildShop->GetItem(shopSlotId)->setQuantity(PChar->PGuildShop->GetItem(shopSlotId)->getQuantity() - quantity);
                PChar->pushPacket<GP_SERV_COMMAND_GUILD_BUY>(PChar, PChar->PGuildShop->GetItem(PChar->PGuildShop->SearchItem(this->ItemNo))->getQuantity(), this->ItemNo, quantity);
                PChar->pushPacket<GP_SERV_COMMAND_ITEM_SAME>(PChar);
            }
        }
    }
    // TODO: error messages!
}
