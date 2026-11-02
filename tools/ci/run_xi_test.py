"""Run xi_test with the arguments given plus the skips listed in xi_test_skips.txt.

--shard I/N runs the Ith of N parts of the test files, balanced by the times in xi_test_durations.json.
--write-durations REPORT... rewrites that file from CTRF reports (xi_test --output REPORT),
such as the xi_test-ctrf-* artifacts of every part of one CI run.
"""

import json
import os
import pathlib
import statistics
import subprocess
import sys

SKIPS = pathlib.Path(__file__).with_name("xi_test_skips.txt")
DURATIONS = pathlib.Path(__file__).with_name("xi_test_durations.json")
TESTS = pathlib.PurePosixPath("scripts/tests")


def skip_args():
    args = []
    for line in SKIPS.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        flag, pattern = line.split(maxsplit=1)
        args += [flag, pattern]
    return args


# xi_test matches --file against paths like scripts/tests\systems\file.lua on Windows.
def file_pattern(path):
    parts = [
        "".join("\\" + c if c in "\\^$.|?*+()[]{}" else c for c in part)
        for part in (str(TESTS), *path.split("/"))
    ]
    return "^" + "[/\\\\]".join(parts) + "$"


def shard_args(shard):
    index, count = (int(part) for part in shard.split("/"))
    durations = json.loads(DURATIONS.read_text(encoding="utf-8"))
    default = statistics.median(durations.values())
    files = sorted(
        path.relative_to("scripts/tests").as_posix()
        for path in pathlib.Path("scripts/tests").rglob("*.lua")
    )

    # Longest first onto the lightest part; a file with no recorded time counts as the median.
    loads = [0.0] * count
    parts = [[] for _ in range(count)]
    for path in sorted(files, key=lambda path: -durations.get(path, default)):
        lightest = loads.index(min(loads))
        parts[lightest].append(path)
        loads[lightest] += durations.get(path, default)

    # No --file at all would run every file.
    return [
        arg for path in parts[index - 1] for arg in ("--file", file_pattern(path))
    ] or ["--file", "^$"]


def write_durations(reports):
    seconds = {}
    for report in reports:
        text = pathlib.Path(report).read_text(encoding="utf-8")
        for test in json.loads(text)["results"]["tests"]:
            path = pathlib.PurePosixPath(test["filePath"].replace("\\", "/"))
            key = path.relative_to(TESTS).as_posix()
            seconds[key] = seconds.get(key, 0) + test["duration"] / 1000

    rounded = {path: round(value, 1) for path, value in sorted(seconds.items())}
    DURATIONS.write_text(json.dumps(rounded, indent=4) + "\n", encoding="utf-8")


def main():
    args = sys.argv[1:]
    if args[:1] == ["--write-durations"]:
        write_durations(args[1:])
        return

    extra = []
    if "--shard" in args:
        at = args.index("--shard")
        extra = shard_args(args[at + 1])
        del args[at : at + 2]

    # Windows does not look in the working directory for a bare program name.
    exe = pathlib.Path.cwd() / ("xi_test.exe" if os.name == "nt" else "xi_test")
    command = [str(exe), *args, *extra, *skip_args()]
    print(" ".join(command), flush=True)
    sys.exit(subprocess.call(command))


if __name__ == "__main__":
    main()
