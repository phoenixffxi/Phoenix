#include "economy_correlator.h"

#include <cstdint>
#include <iostream>
#include <string_view>

namespace
{

using namespace phoenix::economy::correlator;

auto expect(bool condition, std::string_view message) -> bool
{
    if (!condition)
    {
        std::cerr << "FAILED: " << message << '\n';
    }
    return condition;
}

} // namespace

auto main() -> int
{
    auto passed = true;

    const auto debit = reconcileSingle(1000, 700, Direction::Debit);
    passed &= expect(debit.status == Status::Complete && debit.amount == 300, "single debit success");
    passed &= expect(reconcileSingle(1000, 1000, Direction::Debit).status == Status::NoChange,
                     "cancel/no-delta is not an event or gap");
    passed &= expect(reconcileSingle(1000, 1100, Direction::Debit).status == Status::Gap,
                     "single direction mismatch becomes a gap");

    passed &= expect(expiryStatus(false, 1000, 1000) == Status::NoChange,
                     "unobserved failed attempt expires quietly");
    passed &= expect(expiryStatus(true, 1000, 1000) == Status::NoChange,
                     "observed zero-delta attempt expires quietly");
    passed &= expect(expiryStatus(true, 1000, 900) == Status::Gap,
                     "changed unconfirmed attempt expires as a gap");

    ContextDepth contexts;
    for (auto depth = 0; depth < 16; ++depth)
    {
        passed &= expect(beginContext(contexts, 16, true) == ContextBegin::Pushed,
                         "bounded context accepts in-range nesting");
    }
    passed &= expect(beginContext(contexts, 16, true) == ContextBegin::Suppressed &&
                         !semanticContextUsable(contexts),
                     "depth overflow suppresses rather than reusing the outer source");
    passed &= expect(endContext(contexts) == ContextEnd::Unsuppressed && semanticContextUsable(contexts),
                     "overflow suppression unwinds before the outer source");
    while (contexts.depth > 0)
    {
        static_cast<void>(endContext(contexts));
    }
    passed &= expect(beginContext(contexts, 16, true) == ContextBegin::Pushed,
                     "outer context fixture begins");
    passed &= expect(beginContext(contexts, 16, false) == ContextBegin::Suppressed &&
                         !semanticContextUsable(contexts),
                     "invalid nested context suppresses outer attribution");
    passed &= expect(endContext(contexts) == ContextEnd::Unsuppressed && semanticContextUsable(contexts),
                     "invalid nested context restores outer attribution after scope");
    passed &= expect(endContext(contexts) == ContextEnd::Popped && !semanticContextUsable(contexts),
                     "outer context pops cleanly");

    const auto bazaar = reconcileBazaar(5000, 3950, 1000, 1900, 1000);
    passed &= expect(bazaar.status == Status::Complete && bazaar.transfer == 900 && bazaar.tax == 50 &&
                         bazaar.capLoss == 100,
                     "bazaar transfer/tax/cap legs reconcile");
    passed &= expect(reconcileBazaar(5000, 4500, 1000, 1900, 1000).status == Status::Gap,
                     "bazaar incomplete buyer debit is rejected");

    const auto trade = reconcileTrade(1000, 800, 2000, 2200, 300, 100);
    passed &= expect(trade.status == Status::Complete && trade.firstToSecond == 300 &&
                         trade.secondToFirst == 100 && trade.firstCapLoss == 0 && trade.secondCapLoss == 0,
                     "two-party bidirectional trade reconciles");

    const auto cappedTrade = reconcileTrade(1000, 700, 999999900, 999999999, 300, 0);
    passed &= expect(cappedTrade.status == Status::Complete && cappedTrade.firstToSecond == 99 &&
                         cappedTrade.firstCapLoss == 201,
                     "trade cap clipping becomes an explicit cap-loss leg");
    passed &= expect(reconcileTrade(1000, 1000, 2000, 2000, 0, 0).status == Status::NoChange,
                     "item-only trade produces no gil event");
    passed &= expect(reconcileTrade(1000, 950, 2000, 2000, 100, 0).status == Status::Gap,
                     "unreconciled trade legs become a gap");

    const auto partialMint = reconcileMint(1500000000ULL, 100);
    passed &= expect(partialMint.applied == 100 && partialMint.forgone == 1499999900ULL,
                     "over-cap requested mint retains uint32 forgone amount");
    const auto fullyForgone = reconcileMint(1500000000ULL, 0);
    passed &= expect(fullyForgone.applied == 0 && fullyForgone.forgone == 1500000000ULL,
                     "fully clipped over-cap mint is represented");

    if (passed)
    {
        std::cout << "economy correlator contract: PASS\n";
        return 0;
    }
    return 1;
}
