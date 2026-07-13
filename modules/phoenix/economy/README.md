# Phoenix economy telemetry module

This directory is the independently enabled game-side semantic gil module. Runtime code, Lua
overrides, producer tests, and build wiring stay under `modules/phoenix/economy`; no LandSandBoat
core or script file is patched. The module performs no HTTP, network, or database work.

Telemetry is disabled unless explicitly configured. The compiled C++ packet callbacks still incur
their atomic `enabled()` guard while disabled, but no queue, worker thread, spool directory, Lua
override, serialization, or I/O is activated.

## Data flow

`Producer::start()` preallocates the moodycamel queue and registers its sole explicit producer token
before gameplay begins. `Producer::tryRecord()` copies a fixed-size, trivially-copyable accounting
event or diagnostic through tokenized `try_enqueue`, which cannot allocate. All producer calls come
from the same map/game thread; an off-thread record is rejected and reported as a sequence gap. The
hot path does not validate strings, serialize JSON, wait for a lock, or perform I/O. A dedicated
worker validates and sequences records, emits schema-v2 canonical JSON, computes SHA-256,
gzip-compresses at most 500 combined records per batch (and at most 100 of either control type), and
durably completes spool files with temp-file, file flush/fsync, atomic rename, and directory fsync
where supported.

Accounting events carry `semantic` or `correlated` quality plus an evidence version. Unproven wallet
deltas become `attributionGaps`; clipped requested rewards become `forgoneMints`. Both are bounded,
non-accounting controls and never enter mint, burn, or transfer totals.

Startup seeds the first game-thread timestamp, after which the map thread publishes only an atomic
game-tick timestamp/sequence. The worker flushes records within five seconds and writes a quiet
heartbeat within 30 seconds only after observing a newer game tick, so a stalled game loop cannot
manufacture continuing progress. Watermarks cover the latest durable game tick, event, or gap rather
than worker wall-clock time. `Producer::stop()` writes a final watermark.
Filenames begin with the fixed-width boot-start Unix time so the forwarder's lexical scan preserves
chronology across process boots.

Queue overflow, invalid internal events, spool write failure, and spool capacity loss increment the
cumulative dropped counter and are reported through reserved control-only batches. Normal events
and quiet heartbeats cannot consume the configured control reserve. Failed persistence attempts are
rate-limited to one per second; gameplay continues without waiting.

## Configuration

All configuration is read once at module initialization. The producer is off for an unset or false
enable value. The only case-insensitive true values are `1`, `true`, `yes`, and `on`.

| Environment variable | Required when enabled | Default |
|---|---:|---:|
| `PHOENIX_ECONOMY_TELEMETRY_ENABLED` | yes | disabled |
| `PHOENIX_ECONOMY_PRODUCER_ID` | yes | none |
| `PHOENIX_ECONOMY_CONTENT_VERSION` | yes | none |
| `PHOENIX_ECONOMY_SPOOL_DIRECTORY` | yes | none |
| `PHOENIX_ECONOMY_PRODUCER_VERSION` | no | `phoenix-economy-module-0.1.0` |
| `PHOENIX_ECONOMY_QUEUE_CAPACITY` | no | `8192` |
| `PHOENIX_ECONOMY_SPOOL_HARD_CAP_BYTES` | no | `268435456` |
| `PHOENIX_ECONOMY_SPOOL_CONTROL_RESERVE_BYTES` | no | `1048576` |
| `PHOENIX_ECONOMY_FLUSH_INTERVAL_MS` | no | `5000` |
| `PHOENIX_ECONOMY_HEARTBEAT_INTERVAL_MS` | no | `30000` |

Enabling with missing or invalid required values fails closed. No repository setting or production
configuration enables this module.

Every xi_map producer must have a different `PHOENIX_ECONOMY_SPOOL_DIRECTORY`. Queue ownership,
hard-cap accounting, temporary names, and the reserved control allowance are process-local; sharing
one directory would introduce cross-process capacity races and is unsupported. Beta rollout should
use a stable directory containing the producer/map-port identity and grant the local forwarder read,
delete, and directory traversal access.

The spool consumer must accept `.json.gz`, reject decompressed payloads above 1 MiB, process files
in lexical order, and delete a completed file only after the API durably acknowledges it.

Payloads contain numeric character/content IDs and bounded safe-token evidence only, never character
or NPC display names. Treat the spool as internal operational data: keep it outside a served path,
use least-privilege host permissions, and give API credentials only to the separate forwarder.

## Instrumentation API

Instrumentation calls `globalProducer().nextTransactionId(prefix)`, fills an `Event` (including
`occurredAtUnixNanos = unixNanosNow()`), and calls `tryRecord`. An empty event content version is
replaced by the configured version before enqueue. Overloads accept `AttributionGap` and
`ForgoneMint`; event and control sequences are worker-assigned. The worker validates actor direction,
category/source compatibility, typed context, canonical source key, evidence, and numeric bounds.
Invalid internal records are dropped with a `sequence_discontinuity` gap rather than reaching the
spool.

The module owner must call `startFromEnvironment()` during initialization and `stop()` during normal
shutdown. A crash intentionally omits the final watermark so the API can report an ungraceful boot
transition.

## Standalone contract and hot-path test

The module CMake file explicitly adds only runtime sources to xi_map. It is also a standalone test
project; the `.cc` harness invokes the production implementation and independently checks canonical
SHA-256, gzip/decompressed limits, event/control bounds, UINT32 forgone-mint diagnostics, atomic
completion, hard-cap control reserve, queue overflow, capacity/write-failure gaps, cumulative drops,
final watermarks, and enqueue p50/p95/p99.

```sh
cmake -S modules/phoenix/economy -B build/economy-producer-tests
cmake --build build/economy-producer-tests --config Release
ctest --test-dir build/economy-producer-tests -C Release --output-on-failure
```

The producer must remain disabled until the schema-v2 ingest contract is deployed and a beta-only
forwarder/credential has been provisioned.
