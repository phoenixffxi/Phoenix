"""Check that every era and phoenix module file modules/init.txt enables has a test.

A module Lua file is covered by the test at its mirrored path, with the lua folder dropped
(modules/era/lua/combat/tp.lua -> scripts/tests/modules/era/combat/tp.lua), or by any test
file with a "-- Covers: modules/..." line naming it. Covers lines may also name C++ or SQL
module files, so run_xi_test.py knows which tests a change to them needs. Files that can't
be tested under CI's settings are listed in module_test_exemptions.md with the reason.

Run from the repo root: python tools/ci/phoenix/module_test_coverage.py
"""

import os
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[3]
MODULES = ROOT / "modules"
TESTS = ROOT / "scripts" / "tests"
EXEMPTIONS = pathlib.Path(__file__).with_name("module_test_exemptions.md")

# The modules Phoenix owns; custom/ and the rest are LSB's.
SCOPE = ("era", "phoenix")

COVERS = re.compile(r"^--\s*Covers:\s*(\S+)\s*$", re.MULTILINE)


def repo_path(path):
    return path.relative_to(ROOT).as_posix()


# Every init.txt entry, as a path under modules/.
def init_entries():
    entries = []
    for line in (MODULES / "init.txt").read_text(encoding="utf-8").splitlines():
        entry = line.strip().rstrip("/")
        if entry and not entry.startswith("#"):
            entries.append(MODULES / entry)

    return entries


def is_enabled(module_file, entries):
    path = ROOT / module_file
    return path.exists() and any(
        path == entry or path.is_relative_to(entry) for entry in entries
    )


# Module Lua files as git spells them, so a Windows checkout, which folds folders differing
# only in case, reports the paths Linux sees. Falls back to the file system without git.
def module_lua_files():
    try:
        listed = subprocess.run(
            [
                "git",
                "ls-files",
                "--cached",
                "--others",
                "--exclude-standard",
                "--",
                "modules",
            ],
            cwd=ROOT,
            check=True,
            capture_output=True,
            text=True,
        ).stdout.splitlines()
    except (OSError, subprocess.CalledProcessError):
        listed = [repo_path(path) for path in MODULES.rglob("*.lua")]

    return [f for f in listed if f.endswith(".lua") and (ROOT / f).is_file()]


# The era and phoenix module Lua files init.txt enables, the way moduleutils.cpp expands its entries.
def enabled_files(entries):
    owned = [
        repo_path(entry)
        for entry in entries
        if entry.relative_to(MODULES).parts[0] in SCOPE
    ]
    files = {
        f
        for f in module_lua_files()
        if pathlib.PurePosixPath(f).name != "module_utils.lua"
        and any(f == entry or f.startswith(entry + "/") for entry in owned)
    }

    return sorted(files)


def mirror_test(module_file):
    parts = list(pathlib.PurePosixPath(module_file).parts[1:])
    if "lua" in parts:
        parts.remove("lua")

    return "scripts/tests/modules/" + "/".join(parts)


def test_files():
    return sorted(repo_path(path) for path in TESTS.rglob("*.lua"))


def covers_lines(tests):
    found = {}
    for test in tests:
        text = (ROOT / test).read_text(encoding="utf-8")
        found[test] = COVERS.findall(text)

    return found


# Every list item in the exemptions file that is only a code span.
def exemptions():
    entries = []
    for line in EXEMPTIONS.read_text(encoding="utf-8").splitlines():
        match = re.fullmatch(r"- `([^`]+)`", line.strip())
        if match:
            entries.append(match.group(1))

    return entries


# Module file -> the test files that cover it.
def coverage_map(enabled, tests, covers):
    test_set = set(tests)
    covered = {}
    for module_file in enabled:
        mirrored = mirror_test(module_file)
        if mirrored in test_set:
            covered.setdefault(module_file, []).append(mirrored)

    for test, modules in covers.items():
        for module_file in modules:
            covered.setdefault(module_file, [])
            if test not in covered[module_file]:
                covered[module_file].append(test)

    return covered


# The problems found, and how many module files init.txt enables.
def problems():
    entries = init_entries()
    enabled = enabled_files(entries)
    enabled_set = set(enabled)
    tests = test_files()
    covers = covers_lines(tests)
    covered = coverage_map(enabled, tests, covers)
    exempt = exemptions()
    found = []

    for test, modules in covers.items():
        for module_file in modules:
            if module_file not in enabled_set and not is_enabled(module_file, entries):
                found.append(
                    (test, f"Covers {module_file}, which init.txt does not enable")
                )

    for module_file in exempt:
        if not (ROOT / module_file).exists():
            found.append(
                (
                    repo_path(EXEMPTIONS),
                    f"exempts {module_file}, which no longer exists",
                )
            )
        elif module_file in covered:
            found.append(
                (
                    repo_path(EXEMPTIONS),
                    f"exempts {module_file}, which has a test now",
                )
            )
        elif module_file not in enabled_set:
            found.append(
                (
                    repo_path(EXEMPTIONS),
                    f"exempts {module_file}, which init.txt does not enable",
                )
            )

    exempt_set = set(exempt)
    for module_file in enabled:
        if module_file not in covered and module_file not in exempt_set:
            found.append(
                (
                    module_file,
                    f"no test: add {mirror_test(module_file)} or a Covers line",
                )
            )

    return found, len(enabled)


def main():
    found, enabled_count = problems()
    in_actions = os.environ.get("GITHUB_ACTIONS") == "true"
    for path, message in found:
        print(f"{path}: {message}")
        if in_actions:
            print(f"::error file={path}::{message}")

    summary = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary:
        with open(summary, "a", encoding="utf-8") as out:
            if found:
                out.write(
                    f"## :x: {len(found)} module test coverage problem(s)\n\n```\n"
                )
                out.writelines(f"{path}: {message}\n" for path, message in found)
                out.write("```\n")
            else:
                out.write(
                    "## :heavy_check_mark: Every enabled module file has a test\n"
                )

    if found:
        sys.exit(f"\n{len(found)} module test coverage problem(s)")

    print(f"All {enabled_count} enabled module files have a test or an exemption.")


if __name__ == "__main__":
    main()
