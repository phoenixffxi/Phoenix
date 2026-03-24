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

#pragma once

#include "enums/exdata.h"

#include "exdata/base.h"

#include "exdata/legion_pass.h"
#include "exdata/perpetual_hourglass.h"

class CItem;

namespace Exdata
{
auto getType(const CItem* item) -> Type;

auto toTable(const CItem* item, sol::table& table) -> bool;
auto fromTable(CItem* item, const sol::table& data) -> bool;
} // namespace Exdata
