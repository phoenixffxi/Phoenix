"""List functions a PR changes that the enabled modules override, so their copies get the same fix.

Usage: module_override_check.py BASE HEAD [--modules-ref REF] [--repo OWNER/NAME] [--output FILE]

BASE is the branch the PR merges into and HEAD is the PR's head commit.
Upstream functions are compared between their merge base and HEAD.
Overrides are read from --modules-ref, the PR's merge result, because an LSB update's HEAD lacks Phoenix's modules.
Files are only read through git, so nothing from the PR is run.
"""

import argparse
import difflib
import os
import re
import subprocess
import sys
from collections import defaultdict
from dataclasses import dataclass

MARKER = "<!-- phoenix-module-override-check -->"

# Private, and its override names must not appear in a public comment.
EXCLUDED_MODULES = ("phoenix_ac",)

# GitHub rejects comments over 65536 characters.
COMMENT_LIMIT = 60000
# The job summary allows 1 MiB.
SUMMARY_LIMIT = 900000
DIFF_LINE_LIMIT = 150
COMMITS_PER_FUNCTION = 5

TOKEN = re.compile(
    r"""
    (?P<ws>[ \t\r\f\v]+)
  | (?P<nl>\n)
  | (?P<lcomment>--\[(?P<lceq>=*)\[[\s\S]*?\](?P=lceq)\])
  | (?P<comment>--[^\n]*)
  | (?P<lstring>\[(?P<lseq>=*)\[[\s\S]*?\](?P=lseq)\])
  | (?P<string>"(?:\\[\s\S]|[^"\\\n])*"|'(?:\\[\s\S]|[^'\\\n])*')
  | (?P<number>0[xX][0-9a-fA-F]*(?:\.[0-9a-fA-F]*)?(?:[pP][+-]?\d+)?|(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?)
  | (?P<name>[A-Za-z_]\w*)
  | (?P<op>\.\.\.|\.\.|==|~=|<=|>=|::|//|[-+*/%^#&~|<>=(){}\[\];:,.])
    """,
    re.VERBOSE,
)

OPENERS = {"function", "if", "do", "repeat"}
CLOSERS = {"end", "until"}
KEYWORDS = OPENERS | CLOSERS


@dataclass(frozen=True)
class Token:
    kind: str
    text: str
    line: int


@dataclass(frozen=True)
class Definition:
    name: str
    top_level: bool
    start: int
    end: int


@dataclass
class Override:
    target: str
    path: str
    line: int
    replaces: bool


def tokenize(source):
    tokens = []
    line = 1
    pos = 0
    while pos < len(source):
        match = TOKEN.match(source, pos)
        if not match:
            tokens.append(Token("op", source[pos], line))
            pos += 1
            continue

        kind = match.lastgroup
        text = match.group()
        if kind in ("name", "number", "op"):
            tokens.append(Token(kind, text, line))
        elif kind in ("string", "lstring"):
            tokens.append(Token("string", text, line))

        line += text.count("\n")
        pos = match.end()

    return tokens


def block_end(tokens, start):
    depth = 0
    for index in range(start, len(tokens)):
        token = tokens[index]
        if token.kind != "name":
            continue

        if token.text in OPENERS:
            depth += 1
        elif token.text in CLOSERS:
            depth -= 1
            if depth == 0:
                return index

    return len(tokens) - 1


def dotted_name(tokens, index, separators):
    parts = [tokens[index].text]
    index += 1
    while (
        index + 1 < len(tokens)
        and tokens[index].text in separators
        and tokens[index + 1].kind == "name"
    ):
        parts.append(tokens[index + 1].text)
        index += 2

    return ".".join(parts), index


# Finds `function a.b.c(` statements and `a.b.c = function` assignments.
def definitions(tokens):
    found = []
    depth = 0
    for index, token in enumerate(tokens):
        if token.kind != "name":
            continue

        previous = tokens[index - 1].text if index > 0 else ""
        if token.text == "function":
            if index + 1 < len(tokens) and tokens[index + 1].kind == "name":
                name, _ = dotted_name(tokens, index + 1, (".", ":"))
                if previous != "local":
                    found.append(
                        Definition(name, depth == 0, index, block_end(tokens, index))
                    )
        elif token.text not in KEYWORDS and previous not in (".", ":"):
            name, after = dotted_name(tokens, index, (".",))
            if (
                after + 1 < len(tokens)
                and tokens[after].text == "="
                and tokens[after + 1].text == "function"
            ):
                found.append(
                    Definition(name, depth == 0, index, block_end(tokens, after + 1))
                )

        if token.text in OPENERS:
            depth += 1
        elif token.text in CLOSERS:
            depth -= 1

    return found


def matching_paren(tokens, start):
    depth = 0
    for index in range(start, len(tokens)):
        if tokens[index].text == "(":
            depth += 1
        elif tokens[index].text == ")":
            depth -= 1
            if depth == 0:
                return index

    return len(tokens) - 1


def unquote(text):
    if text.startswith("["):
        return text[text.index("[", 1) + 1 : text.rindex("]", 0, -1)]

    return text[1:-1]


# Each override, and whether any function given to it skips super(), so replaces upstream.
def overrides_in(tokens, path):
    found = []
    dynamic = 0
    for index, token in enumerate(tokens):
        if (
            token.text not in ("addOverride", "addOverrideByEra")
            or index == 0
            or tokens[index - 1].text not in (":", ".")
            or index + 1 >= len(tokens)
            or tokens[index + 1].text != "("
        ):
            continue

        close = matching_paren(tokens, index + 1)
        args = tokens[index + 2 : close]
        if len(args) < 2 or args[0].kind != "string" or args[1].text != ",":
            dynamic += 1
            continue

        body = args[2:]
        functions = []
        position = 0
        while position < len(body):
            if body[position].text == "function":
                end = block_end(body, position)
                functions.append(body[position : end + 1])
                position = end
            position += 1

        replaces = not functions or any(
            not any(t.kind == "name" and t.text == "super" for t in function)
            for function in functions
        )
        found.append(Override(unquote(args[0].text), path, token.line, replaces))

    return found, dynamic


class Repo:
    def __init__(self):
        self.cat = subprocess.Popen(
            ["git", "cat-file", "--batch"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
        )
        self.files = {}
        self.tokens = {}

    @staticmethod
    def git(*args):
        return subprocess.run(
            ["git", *args], check=True, capture_output=True, encoding="utf-8"
        ).stdout

    def show(self, ref, path):
        key = (ref, path)
        if key not in self.files:
            self.cat.stdin.write(f"{ref}:{path}\n".encode("utf-8"))
            self.cat.stdin.flush()
            header = self.cat.stdout.readline().decode("utf-8").split()
            if len(header) == 3 and header[1] == "blob":
                data = self.cat.stdout.read(int(header[2]) + 1)[:-1]
                self.files[key] = data.decode("utf-8", errors="replace")
            else:
                self.files[key] = None

        return self.files[key]

    def lua(self, ref, path):
        key = (ref, path)
        if key not in self.tokens:
            source = self.show(ref, path)
            if source is None:
                self.tokens[key] = None
            else:
                tokens = tokenize(source)
                self.tokens[key] = (source, tokens, definitions(tokens))

        return self.tokens[key]


# The paths the server would load the target's table from: scripts/a/b.lua or scripts/globals/a/b.lua is xi.a.b.
def table_files(target, script_paths):
    parts = target.split(".")[:-1]
    if parts and parts[0] == "xi":
        relative = "/".join(parts[1:])
        return [f"scripts/{relative}.lua", f"scripts/globals/{relative}.lua"]

    if len(parts) == 1:
        return [p for p in script_paths if p.rsplit("/", 1)[-1] == f"{parts[0]}.lua"]

    return []


def find(repo, ref, target, paths, table_file):
    function = target.rsplit(".", 1)[-1]
    for path in paths:
        parsed = repo.lua(ref, path)
        if not parsed:
            continue

        source, tokens, defs = parsed
        matches = [d for d in defs if d.name == target]
        if not matches and table_file:
            matches = [
                d
                for d in defs
                if d.top_level and re.fullmatch(rf"\w+\.{re.escape(function)}", d.name)
            ]

        if matches:
            definition = matches[0]
            first = tokens[definition.start].line
            last = tokens[definition.end].line
            body = tuple(t.text for t in tokens[definition.start : definition.end + 1])
            return path, first, last, body, source.split("\n")[first - 1 : last]

    return None


@dataclass
class Change:
    target: str
    status: str
    path: str
    first: int
    last: int
    diff: list
    commits: list


def changed_functions(repo, merge_base, head, targets):
    changed = set(
        repo.git("diff", "--name-only", "--no-renames", merge_base, head).splitlines()
    )
    changed_lua = sorted(p for p in changed if p.endswith(".lua"))
    script_paths = repo.git(
        "ls-tree", "-r", "--name-only", head, "scripts"
    ).splitlines()

    changes = []
    unresolved = []
    for target in sorted(targets):
        candidates = table_files(target, script_paths)
        existing = [
            p
            for p in candidates
            if repo.show(head, p) is not None or repo.show(merge_base, p) is not None
        ]

        if existing and not any(p in changed for p in existing):
            if find(repo, head, target, existing, True):
                continue
            existing = []

        if existing:
            paths, table_file = [p for p in existing if p in changed], True
        else:
            paths, table_file = changed_lua, False

        old = find(repo, merge_base, target, paths, table_file)
        new = find(repo, head, target, paths, table_file)
        if old and not new:
            changes.append(Change(target, "gone", old[0], old[1], old[2], [], []))
        elif old and new and old[3] != new[3]:
            diff = list(
                difflib.unified_diff(old[4], new[4], old[0], new[0], lineterm="", n=2)
            )[2:]
            commits = function_commits(repo, merge_base, head, new[0], new[1], new[2])
            changes.append(
                Change(target, "changed", new[0], new[1], new[2], diff, commits)
            )
        elif not old and not new and existing:
            unresolved.append(target)

    return changes, unresolved


def function_commits(repo, merge_base, head, path, first, last):
    output = repo.git(
        "log",
        "--format=@@commit %H %s",
        f"-L{first},{last}:{path}",
        f"{merge_base}..{head}",
    )
    return [
        line[len("@@commit ") :].split(" ", 1)
        for line in output.splitlines()
        if line.startswith("@@commit ")
    ]


def module_overrides(repo, modules_ref):
    init = repo.show(modules_ref, "modules/init.txt") or ""
    entries = [
        line.strip().rstrip("/")
        for line in init.splitlines()
        if line.strip() and not line.strip().startswith("#")
    ]

    found = []
    dynamic = 0
    for entry in entries:
        if entry.split("/")[0] in EXCLUDED_MODULES:
            continue

        listing = repo.git(
            "ls-tree", "-r", "--name-only", modules_ref, f"modules/{entry}"
        )
        for path in listing.splitlines():
            if not path.endswith(".lua"):
                continue

            parsed = repo.lua(modules_ref, path)
            if parsed:
                overrides, skipped = overrides_in(parsed[1], path)
                found += overrides
                dynamic += skipped

    return found, dynamic


def link(repo_name, sha, path, first, last=None, text=None):
    text = text or f"{path}:{first}"
    if not repo_name:
        return f"`{text}`"

    lines = f"L{first}-L{last}" if last and last != first else f"L{first}"
    return f"[`{text}`](https://github.com/{repo_name}/blob/{sha}/{path}#{lines})"


def commit_link(repo_name, sha, subject):
    subject = subject if len(subject) <= 60 else subject[:57] + "..."
    subject = subject.replace("|", "\\|")
    if not repo_name:
        return f"`{sha[:10]}` {subject}"

    return f"[`{sha[:10]}`](https://github.com/{repo_name}/commit/{sha}) {subject}"


def label(change, override, module_changed):
    if change.status == "gone":
        return "**gone**: no longer defined upstream"

    text = "**replaces it**" if override.replaces else "wraps it (calls `super`)"
    if module_changed:
        text += ", module also changed in this PR"

    return text


def priority(change, override, module_changed):
    if change.status == "gone":
        return 0

    if override.replaces:
        return 2 if module_changed else 1

    return 3


# One block per set of upstream commits, so a sweeping commit is reviewed once.
def group_blocks(changes, overrides_by_target, module_changed, args, refs):
    groups = defaultdict(list)
    subjects = {}
    for change in changes:
        groups[tuple(sha for sha, _ in change.commits)].append(change)
        subjects.update(dict(change.commits))

    ordered = []
    for key, group in groups.items():
        rows = []
        for change in group:
            for override in overrides_by_target[change.target]:
                moved = module_changed(override.path)
                rows.append(
                    (priority(change, override, moved), change, override, moved)
                )
        rows.sort(key=lambda row: (row[0], row[1].target, row[2].path))
        ordered.append((min(row[0] for row in rows), len(group), key, group, rows))
    ordered.sort(key=lambda item: item[:3])

    blocks = []
    for _, _, key, group, rows in ordered:
        heading = ", ".join(
            commit_link(args.repo, sha, subjects[sha])
            for sha in key[:COMMITS_PER_FUNCTION]
        )
        if len(key) > COMMITS_PER_FUNCTION:
            heading += f" and {len(key) - COMMITS_PER_FUNCTION} more"

        table = [
            "",
            f"### {heading or 'No upstream commit found'}",
            "",
            "| Function | Override | Kind |",
            "|---|---|---|",
        ]
        for _, change, override, moved in rows:
            sha = refs["merge_base"] if change.status == "gone" else refs["head"]
            function = link(
                args.repo, sha, change.path, change.first, change.last, change.target
            )
            module = link(args.repo, refs["modules"], override.path, override.line)
            table.append(
                f"| {function} | {module} | {label(change, override, moved)} |"
            )

        diffs = []
        for change in sorted(group, key=lambda change: change.target):
            if not change.diff:
                continue

            diff = change.diff[:DIFF_LINE_LIMIT]
            if len(change.diff) > DIFF_LINE_LIMIT:
                diff.append(f"... {len(change.diff) - DIFF_LINE_LIMIT} more lines")
            diffs += ["", f"`{change.target}`", "", "```diff", *diff, "```"]

        details = ""
        if diffs:
            summary = "Upstream diff" if len(group) == 1 else "Upstream diffs"
            details = "\n".join(
                ["", f"<details><summary>{summary}</summary>", *diffs, "", "</details>"]
            )

        blocks.append(("\n".join(table), details))

    return blocks


def report(changes, overrides_by_target, module_changed, args, refs, limit):
    blocks = group_blocks(changes, overrides_by_target, module_changed, args, refs)
    intro = "\n".join(
        [
            MARKER,
            "## Module override check",
            "",
            f"This PR changes {len(changes)} upstream function(s) that enabled modules override.",
            "Check whether each module needs the same change.",
            "They're grouped by the upstream commits that changed them, smaller groups first.",
        ]
    )
    footer = [
        "",
        f"Compared `{refs['merge_base'][:10]}` with `{refs['head'][:10]}`; "
        f"overrides read from {refs['modules_note']}.",
        "Private modules and overrides with names built at runtime aren't checked.",
    ]

    budget = limit - len(intro) - 1000
    kept = []
    for table, details in blocks:
        if len(table) > budget:
            break
        budget -= len(table)
        kept.append([table, details])

    left_out = 0
    for block in kept:
        if block[1] and len(block[1]) <= budget:
            budget -= len(block[1])
        elif block[1]:
            block[1] = ""
            left_out += 1

    if len(kept) < len(blocks) or left_out:
        missing = []
        if len(kept) < len(blocks):
            missing.append(f"{len(blocks) - len(kept)} group(s)")
        if left_out:
            missing.append(f"{left_out} diff section(s)")
        note = f"{' and '.join(missing)} left out to fit GitHub's comment size limit"
        if refs.get("run_url"):
            note += f"; the [job summary]({refs['run_url']}) has everything"
        footer.append(note + ".")

    body = "".join(table + details for table, details in kept)
    return intro + "\n" + body + "\n" + "\n".join(footer) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("base")
    parser.add_argument("head")
    parser.add_argument("--modules-ref", help="defaults to BASE")
    parser.add_argument("--repo", help="OWNER/NAME, for links")
    parser.add_argument("--output", help="write the report here instead of stdout")
    args = parser.parse_args()

    repo = Repo()
    head = repo.git("rev-parse", args.head).strip()
    base = repo.git("rev-parse", args.base).strip()
    merge_base = repo.git("merge-base", base, head).strip()
    modules_ref = repo.git("rev-parse", args.modules_ref or args.base).strip()

    overrides, dynamic = module_overrides(repo, modules_ref)
    overrides_by_target = defaultdict(list)
    for override in overrides:
        overrides_by_target[override.target].append(override)

    changes, unresolved = changed_functions(repo, merge_base, head, overrides_by_target)

    def module_changed(path):
        if modules_ref == base:
            return repo.show(merge_base, path) != repo.show(head, path)
        return repo.show(base, path) != repo.show(modules_ref, path)

    refs = {
        "head": head,
        "merge_base": merge_base,
        "modules": modules_ref,
        "modules_note": (
            "the PR's merge result"
            if modules_ref != base
            else f"the base branch at `{base[:10]}`"
        ),
    }

    server = os.environ.get("GITHUB_SERVER_URL")
    if server and os.environ.get("GITHUB_RUN_ID"):
        run = f"{os.environ['GITHUB_REPOSITORY']}/actions/runs/{os.environ['GITHUB_RUN_ID']}"
        refs["run_url"] = f"{server}/{run}"

    text = ""
    full = ""
    if changes:
        reported = (changes, overrides_by_target, module_changed, args, refs)
        text = report(*reported, COMMENT_LIMIT)
        full = report(*reported, SUMMARY_LIMIT)

    print(
        f"{len(overrides)} overrides of {len(overrides_by_target)} functions checked, "
        f"{dynamic} with runtime-built names skipped; {len(changes)} changed upstream.",
        file=sys.stderr,
    )
    for target in unresolved:
        print(f"Couldn't find {target} in its changed file.", file=sys.stderr)

    if args.output:
        with open(args.output, "w", encoding="utf-8", newline="\n") as out:
            out.write(text)
    else:
        sys.stdout.write(text)

    if os.environ.get("GITHUB_OUTPUT"):
        with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as out:
            out.write(f"changes={len(changes)}\n")

    if os.environ.get("GITHUB_STEP_SUMMARY"):
        with open(os.environ["GITHUB_STEP_SUMMARY"], "a", encoding="utf-8") as out:
            out.write(full.replace(MARKER, "") if full else "Nothing to review.\n")
            if unresolved:
                out.write("\nCouldn't find these in their changed files:\n\n")
                out.write("".join(f"- `{target}`\n" for target in unresolved))


if __name__ == "__main__":
    main()
