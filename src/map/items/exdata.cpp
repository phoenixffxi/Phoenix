/*
===========================================================================

  Copyright (c) 2026 LandSandBoat Dev Teams

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

#include "exdata.h"

#include "item.h"

#include "items.h"
#include <sol/sol.hpp>

namespace Exdata
{

// Returns Exdata type for an item based on type or item ID.
// This loosely follows client logic for rendering exdata.
auto getType(const CItem* item) -> Type
{
    if (!item)
    {
        return Type::None;
    }

    const auto itemId = item->getID();

    if (itemId == LEGION_PASS)
    {
        return Type::LegionPass;
    }

    if (itemId == PERPETUAL_HOURGLASS)
    {
        return Type::PerpetualHourglass;
    }

    return Type::None;
}

// Fills the table with appropriate keys according to exdata type
auto toTable(const CItem* item, sol::table& table) -> bool
{
    switch (Exdata::getType(item))
    {
        case Type::LegionPass:
            item->exdata<LegionPass>().toTable(table);
            return true;
        case Type::PerpetualHourglass:
            item->exdata<PerpetualHourglass>().toTable(table);
            return true;
        default:
            return false;
    }
}

// Updates item exdata using values from passed table matching exdata type
auto fromTable(CItem* item, const sol::table& data) -> bool
{
    switch (Exdata::getType(item))
    {
        case Type::LegionPass:
            item->exdata<LegionPass>().fromTable(data);
            return true;
        case Type::PerpetualHourglass:
            item->exdata<PerpetualHourglass>().fromTable(data);
            return true;
        default:
            return false;
    }
}

} // namespace Exdata
