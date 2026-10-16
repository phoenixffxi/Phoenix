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

#include <chrono>
#include <cstdint>
#include <unordered_map>

class AHRequestBudget
{
public:
    using Clock = std::chrono::steady_clock;

    auto allow(std::uint32_t ip, std::uint32_t activeAccounts, std::uint32_t requestsPerAccount, Clock::time_point now) -> bool
    {
        if (activeAccounts == 0 || requestsPerAccount == 0)
        {
            return false;
        }

        if (now >= nextCleanup_)
        {
            std::erase_if(windows_,
                          [now](const auto& entry)
                          {
                              return now - entry.second.started >= std::chrono::minutes(1);
                          });
            nextCleanup_ = now + std::chrono::minutes(1);
        }

        auto& window = windows_.try_emplace(ip, Window{ now, 0 }).first->second;
        if (now - window.started >= std::chrono::minutes(1))
        {
            window = Window{ now, 0 };
        }

        const auto limit = static_cast<std::uint64_t>(activeAccounts) * requestsPerAccount;
        if (window.requests >= limit)
        {
            return false;
        }

        ++window.requests;
        return true;
    }

private:
    struct Window
    {
        Clock::time_point started;
        std::uint64_t     requests;
    };

    std::unordered_map<std::uint32_t, Window> windows_;
    Clock::time_point                         nextCleanup_{};
};
