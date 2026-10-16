#include "search/ah_access.h"

#include <catch2/catch_test_macros.hpp>

using namespace std::chrono_literals;

TEST_CASE("AH reads require a live account on every request", "[search][ah-access]")
{
    AHRequestBudget budget;
    const auto      now = AHRequestBudget::Clock::time_point{};

    CHECK_FALSE(budget.allow(1, 0, 120, now));
    CHECK(budget.allow(1, 1, 120, now));
    CHECK_FALSE(budget.allow(1, 0, 120, now + 1s));
}

TEST_CASE("AH connections share a quota per live account and IP", "[search][ah-access]")
{
    AHRequestBudget budget;
    const auto      now = AHRequestBudget::Clock::time_point{};

    CHECK(budget.allow(1, 1, 1, now));
    CHECK_FALSE(budget.allow(1, 1, 1, now));
    CHECK(budget.allow(2, 1, 1, now));
    CHECK(budget.allow(1, 2, 1, now));
    CHECK_FALSE(budget.allow(1, 2, 1, now));
    CHECK_FALSE(budget.allow(1, 1, 1, now));
}

TEST_CASE("AH quotas reset after a minute", "[search][ah-access]")
{
    AHRequestBudget budget;
    const auto      now = AHRequestBudget::Clock::time_point{};

    CHECK(budget.allow(1, 1, 1, now));
    CHECK_FALSE(budget.allow(1, 1, 1, now + 60s - 1ms));
    CHECK(budget.allow(1, 1, 1, now + 60s));
    CHECK_FALSE(budget.allow(1, 1, 1, now + 60s));
}
