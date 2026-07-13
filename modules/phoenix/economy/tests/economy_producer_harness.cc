#include "economy_event.h"
#include "economy_producer.h"

#include <algorithm>
#include <chrono>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <string>
#include <thread>
#include <vector>

namespace
{

using namespace phoenix::economy;

auto configFor(const std::filesystem::path& spool, std::size_t queueCapacity = 8192) -> ProducerConfig
{
    ProducerConfig config;
    config.enabled = true;
    static_cast<void>(config.producerId.assign("test-map-54001"));
    static_cast<void>(config.contentVersion.assign("test-content-v2"));
    static_cast<void>(config.producerVersion.assign("test-producer-1"));
    static_cast<void>(config.spoolDirectory.assign(spool.string()));
    config.queueCapacity                 = queueCapacity;
    config.spoolHardCapBytes             = 32ULL * 1024ULL * 1024ULL;
    config.spoolControlReserveBytes      = 1024ULL * 1024ULL;
    config.flushIntervalMilliseconds     = 1000;
    config.heartbeatIntervalMilliseconds = 30000;
    return config;
}

auto eventFor(std::uint32_t suffix = 1) -> Event
{
    Event event;
    event.occurredAtUnixNanos = unixNanosNow();
    std::array<char, 32> transaction{};
    const auto           length = std::snprintf(transaction.data(), transaction.size(), "test:%u", suffix);
    static_cast<void>(event.transactionId.assign({ transaction.data(), static_cast<std::size_t>(length) }));
    event.kind     = Kind::Mint;
    event.category = Category::StartingGil;
    event.amount   = 123 + suffix % 100;
    event.toCharId.set(1000 + suffix);
    event.sourceType = SourceType::System;
    static_cast<void>(event.sourceKey.assign("system:character-creation"));
    static_cast<void>(event.context.systemKey.assign("character-creation"));
    return event;
}

void printMetrics(std::string_view scenario, const MetricsSnapshot& metrics)
{
    std::cout << scenario << ".enqueued=" << metrics.enqueuedEvents << '\n';
    std::cout << scenario << ".dropped=" << metrics.droppedEvents << '\n';
    std::cout << scenario << ".queue_overflow=" << metrics.queueOverflowEvents << '\n';
    std::cout << scenario << ".producer_thread_violation=" << metrics.producerThreadViolationEvents << '\n';
    std::cout << scenario << ".spool_capacity=" << metrics.spoolCapacityEvents << '\n';
    std::cout << scenario << ".spool_write_failure=" << metrics.spoolWriteFailureEvents << '\n';
    std::cout << scenario << ".batches=" << metrics.batchesWritten << '\n';
}

auto runBasic(const std::filesystem::path& directory) -> bool
{
    Producer producer;
    auto     config = configFor(directory);
    if (producer.start(config) != StartResult::Started)
    {
        return false;
    }

    const auto event                   = eventFor();
    const auto allocationsBefore       = recordQueueAllocationCallsForCurrentThread();
    const auto result                  = producer.tryRecord(event);
    const auto allocationsAfter        = recordQueueAllocationCallsForCurrentThread();
    const auto firstEnqueueAllocations = allocationsAfter - allocationsBefore;
    std::cout << "enqueue.first_thread_allocations=" << firstEnqueueAllocations << '\n';
    if (result != RecordResult::Enqueued || firstEnqueueAllocations != 0)
    {
        return false;
    }

    AttributionGap gap;
    gap.occurredAtUnixNanos = unixNanosNow();
    gap.charId              = 1001;
    gap.direction           = AttributionDirection::Credit;
    gap.appliedDelta        = 50;
    gap.evidenceType        = EvidenceType::WalletObserver;
    static_cast<void>(gap.sourceHint.assign("script:test"));
    static_cast<void>(gap.detailCode.assign("unmatched-wallet-change"));

    ForgoneMint forgone;
    forgone.occurredAtUnixNanos = unixNanosNow();
    forgone.charId              = 1001;
    forgone.requestedAmount     = 4294967295ULL;
    forgone.appliedAmount       = 0;
    forgone.forgoneAmount       = 4294967295ULL;
    forgone.category            = Category::StartingGil;
    static_cast<void>(forgone.transactionId.assign("test:cap"));
    forgone.sourceType = SourceType::System;
    static_cast<void>(forgone.sourceKey.assign("system:character-creation"));
    static_cast<void>(forgone.context.systemKey.assign("character-creation"));
    if (producer.tryRecord(gap) != RecordResult::Enqueued || producer.tryRecord(forgone) != RecordResult::Enqueued)
    {
        return false;
    }
    producer.stop();
    const auto metrics = producer.metrics();
    printMetrics("basic", metrics);
    return metrics.enqueuedEvents == 3 && metrics.droppedEvents == 0 && metrics.batchesWritten >= 2;
}

auto runImmediateStop(const std::filesystem::path& directory) -> bool
{
    Producer producer;
    auto     config = configFor(directory, 32);
    if (producer.start(config) != StartResult::Started)
    {
        return false;
    }

    producer.stop();
    const auto metrics = producer.metrics();
    printMetrics("immediate_stop", metrics);
    return metrics.batchesWritten == 1;
}

auto runOverflow(const std::filesystem::path& directory) -> bool
{
    Producer producer;
    auto     config = configFor(directory, 2);
    if (producer.start(config) != StartResult::Started)
    {
        return false;
    }

    constexpr std::size_t      Iterations = 50000;
    std::vector<std::uint64_t> timings;
    timings.reserve(Iterations);
    const auto event = eventFor(2);
    for (std::size_t index = 0; index < Iterations; ++index)
    {
        const auto start = std::chrono::steady_clock::now();
        static_cast<void>(producer.tryRecord(event));
        const auto end = std::chrono::steady_clock::now();
        timings.push_back(static_cast<std::uint64_t>(
            std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count()));
    }
    producer.stop();

    std::sort(timings.begin(), timings.end());
    const auto p50 = timings[timings.size() * 50 / 100];
    const auto p95 = timings[timings.size() * 95 / 100];
    const auto p99 = timings[timings.size() * 99 / 100];
    std::cout << "enqueue.p50_ns=" << p50 << '\n';
    std::cout << "enqueue.p95_ns=" << p95 << '\n';
    std::cout << "enqueue.p99_ns=" << p99 << '\n';

    const auto metrics = producer.metrics();
    printMetrics("overflow", metrics);
    return metrics.queueOverflowEvents > 0 && metrics.droppedEvents >= metrics.queueOverflowEvents && p99 < 1000000;
}

auto runCapacity(const std::filesystem::path& directory) -> bool
{
    Producer producer;
    auto     config                 = configFor(directory, 2048);
    config.spoolHardCapBytes        = 4096;
    config.spoolControlReserveBytes = 3584;
    if (producer.start(config) != StartResult::Started)
    {
        return false;
    }
    for (std::uint32_t index = 1; index <= MaxEventsPerBatch; ++index)
    {
        if (producer.tryRecord(eventFor(index)) != RecordResult::Enqueued)
        {
            return false;
        }
    }
    producer.stop();
    const auto metrics = producer.metrics();
    printMetrics("capacity", metrics);
    return metrics.spoolCapacityEvents == MaxEventsPerBatch && metrics.droppedEvents == MaxEventsPerBatch &&
           metrics.batchesWritten >= 1;
}

auto runWriteFailure(const std::filesystem::path& directory) -> bool
{
    {
        std::ofstream blocker(directory);
        blocker << "not-a-directory";
    }

    Producer producer;
    auto     config                  = configFor(directory, 32);
    config.flushIntervalMilliseconds = 10;
    if (producer.start(config) != StartResult::Started || producer.tryRecord(eventFor(9)) != RecordResult::Enqueued)
    {
        return false;
    }

    for (auto attempt = 0; attempt < 200 && producer.metrics().spoolWriteFailureEvents == 0; ++attempt)
    {
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
    }
    if (producer.metrics().spoolWriteFailureEvents == 0 || !std::filesystem::remove(directory))
    {
        producer.stop();
        return false;
    }
    std::filesystem::create_directories(directory);
    producer.stop();

    const auto metrics = producer.metrics();
    printMetrics("write_failure", metrics);
    return metrics.spoolWriteFailureEvents == 1 && metrics.droppedEvents == 1 && metrics.batchesWritten >= 1;
}

auto runProducerThreadInvariant(const std::filesystem::path& directory) -> bool
{
    Producer producer;
    auto     config = configFor(directory, 32);
    if (producer.start(config) != StartResult::Started)
    {
        return false;
    }

    auto        result = RecordResult::Disabled;
    std::thread offThread([&producer, &result]
                          {
                              result = producer.tryRecord(eventFor(77));
                          });
    offThread.join();
    producer.stop();

    const auto metrics = producer.metrics();
    printMetrics("thread_invariant", metrics);
    return result == RecordResult::InvalidEvent && metrics.enqueuedEvents == 0 && metrics.droppedEvents == 1 &&
           metrics.producerThreadViolationEvents == 1 && metrics.batchesWritten >= 1;
}

auto runGameTickHeartbeat(const std::filesystem::path& directory) -> bool
{
    Producer producer;
    auto     config                      = configFor(directory, 32);
    config.flushIntervalMilliseconds     = 10;
    config.heartbeatIntervalMilliseconds = 20;
    if (producer.start(config) != StartResult::Started)
    {
        return false;
    }

    producer.noteGameTick();
    for (auto attempt = 0; attempt < 250 && producer.metrics().batchesWritten == 0; ++attempt)
    {
        std::this_thread::sleep_for(std::chrono::milliseconds(2));
    }
    const auto afterFirstTick = producer.metrics().batchesWritten;

    std::this_thread::sleep_for(std::chrono::milliseconds(80));
    const auto afterStall = producer.metrics().batchesWritten;

    producer.noteGameTick();
    for (auto attempt = 0; attempt < 250 && producer.metrics().batchesWritten == afterStall; ++attempt)
    {
        std::this_thread::sleep_for(std::chrono::milliseconds(2));
    }
    const auto afterSecondTick = producer.metrics().batchesWritten;
    producer.stop();

    std::cout << "heartbeat.after_first_tick=" << afterFirstTick << '\n';
    std::cout << "heartbeat.after_stall=" << afterStall << '\n';
    std::cout << "heartbeat.after_second_tick=" << afterSecondTick << '\n';
    printMetrics("heartbeat", producer.metrics());
    return afterFirstTick > 0 && afterStall == afterFirstTick && afterSecondTick > afterStall;
}

auto runControlBounds(const std::filesystem::path& directory) -> bool
{
    Producer producer;
    auto     config = configFor(directory, 1024);
    if (producer.start(config) != StartResult::Started)
    {
        return false;
    }

    for (std::uint32_t index = 1; index <= 150; ++index)
    {
        AttributionGap gap;
        gap.occurredAtUnixNanos = unixNanosNow();
        gap.charId              = 2000 + index;
        gap.direction           = AttributionDirection::Debit;
        gap.appliedDelta        = index;
        gap.evidenceType        = EvidenceType::WalletObserver;
        static_cast<void>(gap.detailCode.assign("control-bound-test"));
        if (producer.tryRecord(gap) != RecordResult::Enqueued)
        {
            return false;
        }
    }
    for (std::uint32_t index = 1; index <= 150; ++index)
    {
        ForgoneMint diagnostic;
        diagnostic.occurredAtUnixNanos = unixNanosNow();
        diagnostic.charId              = 3000 + index;
        diagnostic.requestedAmount     = index + 1;
        diagnostic.appliedAmount       = index;
        diagnostic.forgoneAmount       = 1;
        diagnostic.category            = Category::StartingGil;
        static_cast<void>(diagnostic.transactionId.assign("control-bound:test"));
        diagnostic.sourceType = SourceType::System;
        static_cast<void>(diagnostic.sourceKey.assign("system:character-creation"));
        static_cast<void>(diagnostic.context.systemKey.assign("character-creation"));
        if (producer.tryRecord(diagnostic) != RecordResult::Enqueued)
        {
            return false;
        }
    }
    producer.stop();
    const auto metrics = producer.metrics();
    printMetrics("control_bounds", metrics);
    return metrics.enqueuedEvents == 300 && metrics.droppedEvents == 0 && metrics.batchesWritten >= 3;
}

} // namespace

auto main(int argc, char** argv) -> int
{
    if (argc != 2)
    {
        std::cerr << "usage: economy_producer_harness <empty-output-directory>\n";
        return 2;
    }

    const auto root = std::filesystem::absolute(argv[1]);
    if (std::filesystem::exists(root) && !std::filesystem::is_empty(root))
    {
        std::cerr << "refusing to use a non-empty test output directory\n";
        return 2;
    }
    std::filesystem::create_directories(root);

    const auto basic           = runBasic(root / "basic");
    const auto immediateStop   = runImmediateStop(root / "immediate-stop");
    const auto overflow        = runOverflow(root / "overflow");
    const auto capacity        = runCapacity(root / "capacity");
    const auto writeFailure    = runWriteFailure(root / "write-failure");
    const auto threadInvariant = runProducerThreadInvariant(root / "thread-invariant");
    const auto heartbeat       = runGameTickHeartbeat(root / "heartbeat");
    const auto controlBounds   = runControlBounds(root / "control-bounds");
    return basic && immediateStop && overflow && capacity && writeFailure && threadInvariant && heartbeat &&
                   controlBounds
               ? 0
               : 1;
}
