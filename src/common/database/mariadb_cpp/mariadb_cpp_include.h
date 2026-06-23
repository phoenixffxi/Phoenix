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

// TODO: mariadb-connector-cpp triggers this. Remove once they fix it.
// 4263 'function': member function does not override any base class member functions
#ifdef _WIN32
#pragma warning(push)
#pragma warning(disable : 4263)
#endif

#include <conncpp.hpp>

#ifdef _WIN32
#pragma warning(pop)
#endif
