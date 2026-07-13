#pragma once

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <limits>

namespace phoenix::economy::correlator
{

enum class Status : std::uint8_t
{
    NoChange,
    Complete,
    Gap,
};

enum class Direction : std::uint8_t
{
    Credit,
    Debit,
};

struct ContextDepth
{
    std::size_t  depth{};
    std::uint8_t suppressionDepth{};
};

enum class ContextBegin : std::uint8_t
{
    Pushed,
    Suppressed,
    Rejected,
};

enum class ContextEnd : std::uint8_t
{
    Popped,
    Unsuppressed,
    Empty,
};

[[nodiscard]] constexpr auto beginContext(ContextDepth& state,
                                          std::size_t   capacity,
                                          bool          parsedValid) noexcept -> ContextBegin
{
    if (state.suppressionDepth > 0 || state.depth >= capacity || !parsedValid)
    {
        if (state.suppressionDepth == std::numeric_limits<std::uint8_t>::max())
        {
            return ContextBegin::Rejected;
        }
        ++state.suppressionDepth;
        return ContextBegin::Suppressed;
    }

    ++state.depth;
    return ContextBegin::Pushed;
}

[[nodiscard]] constexpr auto endContext(ContextDepth& state) noexcept -> ContextEnd
{
    if (state.suppressionDepth > 0)
    {
        --state.suppressionDepth;
        return ContextEnd::Unsuppressed;
    }
    if (state.depth > 0)
    {
        --state.depth;
        return ContextEnd::Popped;
    }
    return ContextEnd::Empty;
}

[[nodiscard]] constexpr auto semanticContextUsable(const ContextDepth& state) noexcept -> bool
{
    return state.suppressionDepth == 0 && state.depth > 0;
}

struct SingleResult
{
    Status        status{ Status::Gap };
    std::uint64_t amount{};
};

[[nodiscard]] constexpr auto reconcileSingle(std::uint64_t before,
                                             std::uint64_t after,
                                             Direction     expectedDirection) noexcept -> SingleResult
{
    if (before == after)
    {
        return { Status::NoChange, 0 };
    }

    const auto credit = after > before;
    if ((expectedDirection == Direction::Credit) != credit)
    {
        return { Status::Gap, credit ? after - before : before - after };
    }
    return { Status::Complete, credit ? after - before : before - after };
}

struct BazaarResult
{
    Status        status{ Status::Gap };
    std::uint64_t transfer{};
    std::uint64_t tax{};
    std::uint64_t capLoss{};
};

[[nodiscard]] constexpr auto reconcileBazaar(std::uint64_t buyerBefore,
                                             std::uint64_t buyerAfter,
                                             std::uint64_t sellerBefore,
                                             std::uint64_t sellerAfter,
                                             std::uint64_t baseAmount) noexcept -> BazaarResult
{
    if (baseAmount == 0 || buyerAfter > buyerBefore || sellerAfter < sellerBefore)
    {
        return {};
    }

    const auto buyerDebit = buyerBefore - buyerAfter;
    const auto sellerGain = sellerAfter - sellerBefore;
    if (buyerDebit < baseAmount || sellerGain > baseAmount)
    {
        return {};
    }

    return {
        Status::Complete,
        sellerGain,
        buyerDebit - baseAmount,
        baseAmount - sellerGain,
    };
}

struct TradeResult
{
    Status        status{ Status::Gap };
    std::uint64_t firstToSecond{};
    std::uint64_t secondToFirst{};
    std::uint64_t firstCapLoss{};
    std::uint64_t secondCapLoss{};
};

[[nodiscard]] constexpr auto reconcileTrade(std::uint64_t firstBefore,
                                            std::uint64_t firstAfter,
                                            std::uint64_t secondBefore,
                                            std::uint64_t secondAfter,
                                            std::uint64_t firstOffer,
                                            std::uint64_t secondOffer) noexcept -> TradeResult
{
    if (firstOffer == 0 && secondOffer == 0)
    {
        return { Status::NoChange };
    }

    const auto firstCreditSigned  = static_cast<std::int64_t>(firstAfter) -
                                    static_cast<std::int64_t>(firstBefore) +
                                    static_cast<std::int64_t>(firstOffer);
    const auto secondCreditSigned = static_cast<std::int64_t>(secondAfter) -
                                    static_cast<std::int64_t>(secondBefore) +
                                    static_cast<std::int64_t>(secondOffer);
    if (firstCreditSigned < 0 || secondCreditSigned < 0 ||
        firstCreditSigned > static_cast<std::int64_t>(secondOffer) ||
        secondCreditSigned > static_cast<std::int64_t>(firstOffer))
    {
        return {};
    }

    const auto secondToFirst = static_cast<std::uint64_t>(firstCreditSigned);
    const auto firstToSecond = static_cast<std::uint64_t>(secondCreditSigned);
    return {
        Status::Complete,
        firstToSecond,
        secondToFirst,
        firstOffer - firstToSecond,
        secondOffer - secondToFirst,
    };
}

[[nodiscard]] constexpr auto expiryStatus(bool          walletObserved,
                                          std::uint64_t before,
                                          std::uint64_t latest) noexcept -> Status
{
    return walletObserved && before != latest ? Status::Gap : Status::NoChange;
}

struct MintClip
{
    std::uint64_t applied{};
    std::uint64_t forgone{};
};

[[nodiscard]] constexpr auto reconcileMint(std::uint64_t requested, std::uint64_t applied) noexcept -> MintClip
{
    return { applied, requested > applied ? requested - applied : 0 };
}

} // namespace phoenix::economy::correlator
