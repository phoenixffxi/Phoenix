"""Run xi_test with the arguments given plus the skips listed in xi_test_skips.md.

Picks how much to run:
- full: everything. Used for the weekly LSB update PR (title contains "update"), runs that
  aren't for a pull request, local runs, and PRs that change core C++ under src/, the skip
  list or setup_tests.py.
- quick: every module test except its #exhaustive cases, plus all cases of the tests for
  the files the PR changes. Used for other pull requests.
--tier quick|full overrides the choice; a local quick run needs --base REF to diff against.
"""

import argparse
import functools
import json
import os
import pathlib
import re
import subprocess
import sys

import module_test_coverage as coverage
from setup_tests import ERA

ROOT = coverage.ROOT
SKIPS = pathlib.Path(__file__).with_name("xi_test_skips.md")

# Changes that can break the upstream tests a quick run leaves out.
FULL_RUN = (
    "src/",
    "tools/ci/phoenix/xi_test_skips.md",
    "tools/ci/phoenix/setup_tests.py",
)

TARGET = re.compile(r"""addOverride(?:ByEra)?\s*\(\s*['"]([^'"]+)['"]""")
DESCRIBE = re.compile(
    r"""^describe\(\s*(?:'((?:[^'\\]|\\.)*)'|"((?:[^"\\]|\\.)*)")""", re.MULTILINE
)
DEFINED = re.compile(
    r"^[ \t]*(?:function[ \t]+(xi(?:\.\w+)+)[ \t]*\(|(xi(?:\.\w+)+)[ \t]*=(?!=))",
    re.MULTILINE,
)
GUARD = re.compile(
    r"^[ \t]*(xi(?:\.\w+)+)[ \t]*=[ \t]*\1[ \t]+or[ \t]+\{[ \t]*\}", re.MULTILINE
)


# Each list item that is only a code span is a pattern to skip.
def skip_args():
    args = []
    for line in SKIPS.read_text(encoding="utf-8").splitlines():
        match = re.fullmatch(r"- `([^`]+)`", line.strip())
        if match:
            args += ["--no-filter", match.group(1)]
    return args


def git(*args):
    return subprocess.run(
        ["git", *args], cwd=ROOT, check=True, capture_output=True, text=True
    ).stdout


def pull_request():
    if os.environ.get("GITHUB_EVENT_NAME") not in (
        "pull_request",
        "pull_request_target",
    ):
        return None

    with open(os.environ["GITHUB_EVENT_PATH"], encoding="utf-8") as event:
        return json.load(event).get("pull_request")


# Locally, the committed, uncommitted and untracked changes since base. CI checks out the PR's
# merge commit one deep, so it fetches the parents to diff against the base.
def changed_files(base):
    if base:
        merge_base = git("merge-base", base, "HEAD").strip()
        return (
            git("diff", "--name-only", merge_base).splitlines()
            + git("ls-files", "--others", "--exclude-standard").splitlines()
        )

    head = git("rev-parse", "HEAD").strip()
    git("fetch", "--no-tags", "--depth=2", "origin", head)
    return git("diff", "--name-only", "HEAD^1", "HEAD").splitlines()


def choose_tier(args):
    if args.tier != "auto":
        return args.tier, f"--tier {args.tier}"

    pr = pull_request()
    if pr is None:
        return "full", "not a pull request"

    if "update" in pr.get("title", "").lower():
        return "full", "the PR title contains 'update'"

    return "quick", "pull request"


# Lua source without comments, or empty for a file that no longer exists.
@functools.cache
def lua_source(path):
    file = ROOT / path
    if not file.is_file():
        return ""

    text = file.read_text(encoding="utf-8", errors="replace")
    text = re.sub(r"--\[(=*)\[.*?\]\1\]", "", text, flags=re.DOTALL)
    return re.sub(r"--[^\n]*", "", text)


# The module files a change to scripts/<path>.lua can break: ones overriding a function it
# defines, keyed the way moduleutils.cpp's TryApplyLuaModules keys it or by the xi.* names it
# assigns (damage_spell.lua fills xi.spells.damage), or naming it, as modifyInteractionEntry does.
def modules_using_script(script, module_files):
    parts = list(pathlib.PurePosixPath(script).with_suffix("").parts[1:])
    named = "scripts/" + "/".join(parts)
    if parts and parts[0] == "globals":
        parts = parts[1:]

    source = lua_source(script)
    defined = {a or b for a, b in DEFINED.findall(source)} - set(GUARD.findall(source))
    keys = tuple(name + "." for name in defined)
    if parts:
        keys += ("xi." + ".".join(parts) + ".", parts[-1] + ".")

    users = []
    for module_file in module_files:
        module_source = lua_source(module_file)
        targets = TARGET.findall(module_source)
        if named in module_source or any(
            t in defined or t.startswith(keys) for t in targets
        ):
            users.append(module_file)

    return users


# The tests a quick run gives all their cases, or None when the change needs the full run.
def touched_tests(changed, covered, module_tests):
    module_files = [f for f in covered if f.endswith(".lua")]
    touched = set()
    for path in changed:
        if path.startswith(FULL_RUN):
            return None

        if path.startswith("scripts/tests/helpers/") or path in (
            "modules/init.txt",
            "modules/module_utils.lua",
        ):
            touched.update(module_tests)
        elif path.startswith("scripts/tests/") and path.endswith(".lua"):
            if (ROOT / path).exists():
                touched.add(path)
        elif path.startswith("modules/"):
            touched.update(covered.get(path, []))
        elif path.startswith("scripts/") and path.endswith(".lua"):
            for module_file in modules_using_script(path, module_files):
                touched.update(covered[module_file])

    return touched


def path_pattern(test):
    relative = pathlib.PurePosixPath(test).relative_to("scripts/tests")
    return (
        "^scripts[/\\\\]tests[/\\\\]"
        + "[/\\\\]".join(regex_escape(part) for part in relative.parts)
        + "$"
    )


# Only the characters std::regex treats as special, so the pattern stays readable.
def regex_escape(text):
    return re.sub(r"([\\^$.|?*+()\[\]{}])", r"\\\1", text)


# The start of every test name in a file: its folders, then each top-level describe. Without
# a describe titled by a plain string at the start of a line, it falls back to the folders,
# which also gives the other tests there all their cases.
def name_prefixes(test):
    relative = pathlib.PurePosixPath(test).relative_to("scripts/tests")
    folders = "::".join(relative.parts[:-1])
    prefixes = []
    for single, double in DESCRIBE.findall((ROOT / test).read_text(encoding="utf-8")):
        title = re.sub(r"\\(.)", r"\1", single or double)
        prefixes.append(f"{folders}::{title}::" if folders else f"{title}::")

    if not prefixes:
        print(
            f"  {test} has no plain describe title, so its whole folder runs in full",
            flush=True,
        )
        prefixes.append(f"{folders}::" if folders else "")

    return prefixes


def quick_args(changed):
    tests = coverage.test_files()
    covered = coverage.coverage_map(
        coverage.enabled_files(coverage.init_entries()),
        tests,
        coverage.covers_lines(tests),
    )
    covering = {test for listed in covered.values() for test in listed}
    module_tests = sorted(
        covering | {t for t in tests if t.startswith("scripts/tests/modules/")}
    )

    touched = touched_tests(changed, covered, module_tests)
    if touched is None:
        return None

    selected = sorted(set(module_tests) | touched)
    print(
        f"Quick run: {len(selected)} test files, {len(touched)} with every case",
        flush=True,
    )
    for test in sorted(touched):
        print(f"  all cases: {test}", flush=True)

    args = ["--file", "^scripts[/\\\\]tests[/\\\\]modules[/\\\\]"]
    for test in selected:
        if not test.startswith("scripts/tests/modules/"):
            args += ["--file", path_pattern(test)]

    prefixes = [
        regex_escape(p) for test in sorted(touched) for p in name_prefixes(test)
    ]
    if prefixes:
        args += ["--no-filter", f"^(?!(?:{'|'.join(prefixes)})).*#exhaustive"]
    else:
        args += ["--no-tag", "exhaustive"]

    return args


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0], add_help=False)
    parser.add_argument("--tier", choices=["auto", "quick", "full"], default="auto")
    parser.add_argument("--base", help="ref a local quick run diffs against")
    args, xi_test_args = parser.parse_known_args()

    # Without a base, the changes come from CI's merge commit.
    if (
        args.tier == "quick"
        and not args.base
        and os.environ.get("GITHUB_ACTIONS") != "true"
    ):
        parser.error("--tier quick needs --base REF outside CI")

    tier, reason = choose_tier(args)
    selection = []
    if tier == "quick":
        try:
            changed = changed_files(args.base)
        except (OSError, subprocess.CalledProcessError) as error:
            detail = (getattr(error, "stderr", None) or str(error)).strip()
            print(
                f"Could not list the changed files ({detail}), running everything",
                flush=True,
            )
            changed = None

        selection = quick_args(changed) if changed is not None else None
        if selection is None:
            tier, reason, selection = (
                "full",
                "the change can't be narrowed to module tests",
                [],
            )

    print(f"Tier: {tier} ({reason})", flush=True)

    # Windows does not look in the working directory for a bare program name.
    exe = pathlib.Path.cwd() / ("xi_test.exe" if os.name == "nt" else "xi_test")
    command = [str(exe), *xi_test_args, *selection, *skip_args()]
    print(" ".join(command), flush=True)

    # The era settings CI uses, unless the environment already sets them.
    sys.exit(subprocess.call(command, env={**ERA, **os.environ}))


if __name__ == "__main__":
    main()
