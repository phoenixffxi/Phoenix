#!/usr/bin/env python3
"""Exercise the production producer and independently validate its spool contract."""

from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import re
import subprocess
import tempfile
from pathlib import Path


FILE_NAME = re.compile(
    r"^economy-(?P<started>[0-9]{13})-[0-9a-f-]{36}-(?P<sequence>[0-9]{20})\.json\.gz$"
)


def canonical(value: object) -> bytes:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode()


def load_batches(directory: Path) -> list[dict[str, object]]:
    assert not list(directory.glob("*.tmp")), f"temporary files survived atomic completion in {directory}"
    files = sorted(directory.glob("*.json.gz"))
    assert files, f"no completed batches in {directory}"
    assert all(FILE_NAME.fullmatch(path.name) for path in files)

    batches: list[dict[str, object]] = []
    for path in files:
        raw = gzip.decompress(path.read_bytes())
        assert len(raw) <= 1024 * 1024
        batch = json.loads(raw)
        checksum = batch.pop("checksum")
        assert checksum == hashlib.sha256(canonical(batch)).hexdigest(), path
        assert batch["schemaVersion"] == 2
        assert batch["eventCount"] == len(batch["events"])
        assert batch["controlCount"] == len(batch["attributionGaps"]) + len(batch["forgoneMints"])
        assert batch["eventCount"] + batch["controlCount"] <= 500
        assert len(batch["attributionGaps"]) <= 100
        assert len(batch["forgoneMints"]) <= 100
        control_sequences = sorted(
            int(control["controlSeq"])
            for control in [*batch["attributionGaps"], *batch["forgoneMints"]]
        )
        if control_sequences:
            assert int(batch["firstControlSeq"]) == control_sequences[0]
            assert int(batch["lastControlSeq"]) == control_sequences[-1]
        else:
            assert batch["firstControlSeq"] is None
            assert batch["lastControlSeq"] is None
        batches.append(batch)
    return batches


def parse_metrics(output: str) -> dict[str, int]:
    metrics: dict[str, int] = {}
    for line in output.splitlines():
        key, value = line.split("=", 1)
        metrics[key] = int(value)
    return metrics


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--harness", required=True, type=Path)
    args = parser.parse_args()

    with tempfile.TemporaryDirectory(prefix="phoenix-economy-test-") as temporary:
        root = Path(temporary)
        result = subprocess.run(
            [str(args.harness.resolve()), str(root)],
            check=True,
            capture_output=True,
            text=True,
        )
        metrics = parse_metrics(result.stdout)
        assert metrics["enqueue.first_thread_allocations"] == 0

        basic = load_batches(root / "basic")
        basic_events = [event for batch in basic for event in batch["events"]]
        assert len(basic_events) == 1
        assert basic_events[0]["contentVersion"] == "test-content-v2"
        assert basic_events[0]["attributionQuality"] == "semantic"
        assert basic_events[0]["evidenceVersion"] == "test-producer-1"
        assert basic_events[0]["context"] == {"systemKey": "character-creation"}
        assert basic_events[0]["sourceKey"] == "system:character-creation"
        basic_attribution_gaps = [gap for batch in basic for gap in batch["attributionGaps"]]
        basic_forgone = [diagnostic for batch in basic for diagnostic in batch["forgoneMints"]]
        assert len(basic_attribution_gaps) == 1
        assert basic_attribution_gaps[0]["appliedDelta"] == "50"
        assert basic_attribution_gaps[0]["evidenceType"] == "wallet_observer"
        assert len(basic_forgone) == 1
        assert basic_forgone[0]["forgoneAmount"] == "4294967295"
        assert basic_forgone[0]["requestedAmount"] == "4294967295"
        assert basic_forgone[0]["appliedAmount"] == "0"
        assert any(batch["controlCount"] == 2 for batch in basic)
        assert basic[-1]["finalWatermark"] is True

        immediate_stop = load_batches(root / "immediate-stop")
        assert len(immediate_stop) == 1
        assert immediate_stop[0]["finalWatermark"] is True
        assert immediate_stop[0]["watermarkThrough"] > "2020-01-01T00:00:00.000Z"

        overflow = load_batches(root / "overflow")
        overflow_gaps = [gap for batch in overflow for gap in batch["gaps"]]
        assert any(gap["reason"] == "queue_overflow" for gap in overflow_gaps)
        assert max(int(batch["droppedEvents"]) for batch in overflow) == metrics["overflow.dropped"]
        assert metrics["overflow.queue_overflow"] > 0
        assert metrics["enqueue.p99_ns"] < 1_000_000

        capacity = load_batches(root / "capacity")
        capacity_gaps = [gap for batch in capacity for gap in batch["gaps"]]
        assert any(gap["reason"] == "spool_capacity" for gap in capacity_gaps)
        assert metrics["capacity.spool_capacity"] == 500
        assert sum(path.stat().st_size for path in (root / "capacity").iterdir()) <= 4096

        write_failure = load_batches(root / "write-failure")
        write_failure_gaps = [gap for batch in write_failure for gap in batch["gaps"]]
        assert any(gap["reason"] == "spool_write_failure" for gap in write_failure_gaps)
        assert metrics["write_failure.spool_write_failure"] == 1

        thread_invariant = load_batches(root / "thread-invariant")
        thread_gaps = [gap for batch in thread_invariant for gap in batch["gaps"]]
        assert any(gap["reason"] == "sequence_discontinuity" for gap in thread_gaps)
        assert metrics["thread_invariant.producer_thread_violation"] == 1

        heartbeat = load_batches(root / "heartbeat")
        quiet_heartbeats = [
            batch
            for batch in heartbeat
            if not batch["finalWatermark"]
            and batch["eventCount"] == 0
            and batch["controlCount"] == 0
            and not batch["gaps"]
        ]
        assert metrics["heartbeat.after_first_tick"] == metrics["heartbeat.after_stall"]
        assert metrics["heartbeat.after_second_tick"] > metrics["heartbeat.after_stall"]
        assert len(quiet_heartbeats) == 2
        assert quiet_heartbeats[0]["watermarkThrough"] < quiet_heartbeats[1]["watermarkThrough"]

        control_bounds = load_batches(root / "control-bounds")
        assert sum(batch["controlCount"] for batch in control_bounds) == 300
        assert sum(len(batch["attributionGaps"]) for batch in control_bounds) == 150
        assert sum(len(batch["forgoneMints"]) for batch in control_bounds) == 150

        print(result.stdout, end="")
        print(
            "validated_batches="
            f"{len(basic) + len(immediate_stop) + len(overflow) + len(capacity) + len(write_failure) + len(thread_invariant) + len(heartbeat) + len(control_bounds)}"
        )


if __name__ == "__main__":
    main()
