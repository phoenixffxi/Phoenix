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

#include "search/ah_access.h"

#include <catch2/catch_test_macros.hpp>

#include <limits>

using namespace std::chrono_literals;

TEST_CASE("AH reads require a live account on every request", "[search][ah-access]")
{
    AHRequestBudget budget;
    const auto      now = AHRequestBudget::Clock::time_point{};

    CHECK_FALSE(budget.allow(1, 0, 120, now));
    CHECK(budget.allow(1, 1, 120, now));
    CHECK_FALSE(budget.allow(1, 0, 120, now + 1s));
    CHECK(budget.allow(1, 1, 120, now + 2s));
}

TEST_CASE("AH request budgets persist across connections from one IP", "[search][ah-access]")
{
    AHRequestBudget budget;
    const auto      now = AHRequestBudget::Clock::time_point{};

    CHECK(budget.allow(1, 1, 2, now));
    CHECK(budget.allow(1, 1, 2, now + 1s));
    CHECK_FALSE(budget.allow(1, 1, 2, now + 2s));
    CHECK(budget.allow(2, 1, 2, now + 2s));
}

TEST_CASE("AH budgets scale with live accounts sharing an IP", "[search][ah-access]")
{
    AHRequestBudget budget;
    const auto      now = AHRequestBudget::Clock::time_point{};

    CHECK(budget.allow(1, 2, 1, now));
    CHECK(budget.allow(1, 2, 1, now));
    CHECK_FALSE(budget.allow(1, 2, 1, now));
    CHECK_FALSE(budget.allow(1, 1, 1, now));
    CHECK(budget.allow(1, 3, 1, now));
}

TEST_CASE("AH budgets reset after a minute without admitting an early retry", "[search][ah-access]")
{
    AHRequestBudget budget;
    const auto      now = AHRequestBudget::Clock::time_point{};

    CHECK(budget.allow(1, 1, 1, now));
    CHECK_FALSE(budget.allow(1, 1, 1, now + 60s - 1ms));
    CHECK(budget.allow(1, 1, 1, now + 60s));
    CHECK_FALSE(budget.allow(1, 1, 1, now + 60s));
    CHECK(budget.allow(1, 1, 1, now + 10min));
}

TEST_CASE("AH budgets handle staggered windows and a disabled quota", "[search][ah-access]")
{
    AHRequestBudget budget;
    const auto      now = AHRequestBudget::Clock::time_point{};

    CHECK_FALSE(budget.allow(1, 1, 0, now));
    CHECK(budget.allow(1, 1, 1, now));
    CHECK(budget.allow(2, 1, 1, now + 30s));
    CHECK(budget.allow(1, 1, 1, now + 60s));
    CHECK_FALSE(budget.allow(2, 1, 1, now + 60s));
    CHECK(budget.allow(2, 1, 1, now + 90s));
}

TEST_CASE("AH shared-IP quotas do not overflow 32 bits", "[search][ah-access]")
{
    AHRequestBudget budget;
    const auto      now = AHRequestBudget::Clock::time_point{};

    CHECK(budget.allow(1, 2, std::numeric_limits<std::uint32_t>::max(), now));
    CHECK(budget.allow(1, 65536, 65536, now));
}
