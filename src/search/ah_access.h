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
