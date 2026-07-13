#pragma once

#include "economy_event.h"

#include <cstddef>
#include <cstdint>
#include <memory>
#include <string_view>

namespace phoenix::economy
{

constexpr std::size_t MaxEventsPerBatch = 500;

struct ProducerConfig
{
    bool enabled{};

    FixedString<128> producerId;
    ContentVersion   contentVersion;
    FixedString<64>  producerVersion;
    FixedString<512> spoolDirectory;

    std::size_t   queueCapacity{ 8192 };
    std::uint64_t spoolHardCapBytes{ 256ULL * 1024ULL * 1024ULL };
    std::uint64_t spoolControlReserveBytes{ 1024ULL * 1024ULL };
    std::uint32_t flushIntervalMilliseconds{ 5000 };
    std::uint32_t heartbeatIntervalMilliseconds{ 30000 };
};

enum class StartResult : std::uint8_t
{
    Started,
    Disabled,
    AlreadyStarted,
    InvalidConfiguration,
    WorkerStartFailed,
};

enum class RecordResult : std::uint8_t
{
    Enqueued,
    Disabled,
    InvalidEvent,
    QueueFull,
};

struct MetricsSnapshot
{
    std::uint64_t enqueuedEvents{};
    std::uint64_t droppedEvents{};
    std::uint64_t queueOverflowEvents{};
    std::uint64_t producerThreadViolationEvents{};
    std::uint64_t invalidEvents{};
    std::uint64_t spoolCapacityEvents{};
    std::uint64_t spoolWriteFailureEvents{};
    std::uint64_t batchesWritten{};
    std::uint64_t reportedSpoolBytes{};
};

class Producer final
{
public:
    Producer();
    ~Producer();

    Producer(const Producer&)            = delete;
    Producer& operator=(const Producer&) = delete;
    Producer(Producer&&)                 = delete;
    Producer& operator=(Producer&&)      = delete;

    [[nodiscard]] auto start(const ProducerConfig& config) noexcept -> StartResult;
    [[nodiscard]] auto startFromEnvironment() noexcept -> StartResult;

    // stop() joins the spool worker and asks it to durably write a final
    // watermark. It is idempotent and must be called during graceful shutdown.
    void stop() noexcept;

    // start(), noteGameTick(), nextTransactionId(), and every tryRecord()
    // call belong to the same map/game thread. start() pre-registers the
    // queue's sole explicit producer token before returning; off-thread
    // tryRecord() calls are rejected and reported as sequence gaps.
    void noteGameTick() noexcept;

    [[nodiscard]] auto tryRecord(Event event) noexcept -> RecordResult;
    [[nodiscard]] auto tryRecord(AttributionGap gap) noexcept -> RecordResult;
    [[nodiscard]] auto tryRecord(ForgoneMint diagnostic) noexcept -> RecordResult;
    [[nodiscard]] auto nextTransactionId(std::string_view prefix) noexcept -> TransactionId;
    [[nodiscard]] auto enabled() const noexcept -> bool;
    [[nodiscard]] auto metrics() const noexcept -> MetricsSnapshot;
    [[nodiscard]] auto lastError() const noexcept -> const char*;

private:
    struct Impl;
    std::unique_ptr<Impl> impl_;
};

[[nodiscard]] auto globalProducer() noexcept -> Producer&;
[[nodiscard]] auto producerConfigFromEnvironment() noexcept -> ProducerConfig;

#ifdef PHOENIX_ECONOMY_TESTING
[[nodiscard]] auto recordQueueAllocationCallsForCurrentThread() noexcept -> std::uint64_t;
#endif

} // namespace phoenix::economy
