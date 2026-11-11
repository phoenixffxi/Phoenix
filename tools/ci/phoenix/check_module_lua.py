"""Run the Lua language server on modules/, with scripts/ loaded only for its definitions.

LSB's Lua Language Server job checks scripts/, and this checks the modules, so nothing else in the repo gets flagged.
Only problems in modules that modules/init.txt enables are reported, since the server loads nothing else.
Uses .vscode/settings.json for everything else, the same config LSB's job uses.
Downloads the latest LuaLS release into ./lua-language-server unless --luals points at a binary.

Run from the repo root: python tools/ci/phoenix/check_module_lua.py
"""

import argparse
import json
import os
import pathlib
import platform
import subprocess
import sys
import tarfile
import tempfile
import urllib.parse
import urllib.request
import zipfile

ROOT = pathlib.Path(__file__).resolve().parents[3]

# phoenix_ac is private and not in CI's checkout; phoenix_archive is no longer loaded.
SKIPPED = ["/phoenix_ac", "/phoenix_archive"]

ASSETS = {
    "Windows": "win32-x64.zip",
    "Linux": "linux-x64.tar.gz",
    "Darwin": "darwin-x64.tar.gz",
}

ANNOTATIONS = {1: "error", 2: "warning"}


# VS Code settings allow comments and trailing commas, which json rejects.
def read_jsonc(text):
    kept = []
    index = 0
    in_string = False
    while index < len(text):
        char = text[index]
        if in_string:
            kept.append(char)
            if char == "\\":
                kept.append(text[index + 1])
                index += 1
            elif char == '"':
                in_string = False
        elif char == '"':
            in_string = True
            kept.append(char)
        elif text.startswith("//", index):
            end = text.find("\n", index)
            index = (len(text) if end == -1 else end) - 1
        elif text.startswith("/*", index):
            index = text.index("*/", index) + 1
        elif char == ",":
            following = text[index + 1 :].lstrip()
            if not following.startswith(("]", "}")):
                kept.append(char)
        else:
            kept.append(char)
        index += 1

    return json.loads("".join(kept))


def download(folder):
    asset = ASSETS[platform.system()]
    request = urllib.request.Request(
        "https://api.github.com/repos/LuaLS/lua-language-server/releases/latest"
    )
    if os.environ.get("GITHUB_TOKEN"):
        request.add_header("Authorization", f"Bearer {os.environ['GITHUB_TOKEN']}")

    with urllib.request.urlopen(request) as response:
        release = json.load(response)

    url = next(
        a["browser_download_url"]
        for a in release["assets"]
        if a["name"].endswith(asset)
    )
    print(f"Downloading {url}", flush=True)
    with tempfile.TemporaryDirectory() as temp:
        archive = pathlib.Path(temp) / asset
        urllib.request.urlretrieve(url, archive)
        if asset.endswith(".zip"):
            with zipfile.ZipFile(archive) as zipped:
                zipped.extractall(folder)
        else:
            with tarfile.open(archive, "r:gz") as tarred:
                tarred.extractall(folder, filter="data")


def luals(path):
    if path:
        return pathlib.Path(path)

    name = (
        "lua-language-server.exe"
        if platform.system() == "Windows"
        else "lua-language-server"
    )
    binary = ROOT / "lua-language-server" / "bin" / name
    if not binary.exists():
        download(binary.parents[1])

    return binary


def write_config(path):
    settings = read_jsonc(
        (ROOT / ".vscode" / "settings.json").read_text(encoding="utf-8")
    )
    config = {key: value for key, value in settings.items() if key.startswith("Lua.")}
    config["Lua.workspace.library"] = [
        *config.get("Lua.workspace.library", []),
        str(ROOT / "scripts"),
    ]
    config["Lua.workspace.ignoreDir"] = [
        *config.get("Lua.workspace.ignoreDir", []),
        *SKIPPED,
    ]
    path.write_text(json.dumps(config, indent=4), encoding="utf-8")


# The paths modules/init.txt enables, such as modules/era/lua or modules/custom/lua/claim_shield.lua.
def enabled_paths():
    init = (ROOT / "modules" / "init.txt").read_text(encoding="utf-8")
    entries = [line.strip().rstrip("/") for line in init.splitlines()]
    return [
        f"modules/{entry}" for entry in entries if entry and not entry.startswith("#")
    ]


def repo_path(uri):
    path = urllib.parse.unquote(urllib.parse.urlparse(uri).path)
    # file:///d%3A/... on Windows
    if len(path) > 2 and path[0] == "/" and path[2] == ":":
        path = path[1:]

    try:
        return pathlib.Path(path).resolve().relative_to(ROOT).as_posix()
    except ValueError:
        return path


# Workflow command values can't hold raw newlines, and properties can't hold : or , either.
def escape(text, property_value=False):
    text = text.replace("%", "%25").replace("\r", "%0D").replace("\n", "%0A")
    if property_value:
        text = text.replace(":", "%3A").replace(",", "%2C")

    return text


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--luals", help="path to a lua-language-server binary")
    args = parser.parse_args()

    binary = luals(args.luals)
    with tempfile.TemporaryDirectory() as temp:
        config = pathlib.Path(temp) / "luals.json"
        write_config(config)
        command = [
            str(binary),
            f"--check={ROOT / 'modules'}",
            f"--configpath={config}",
            "--check_format=json",
            "--checklevel=Information",
            f"--logpath={temp}",
        ]
        print(" ".join(command), flush=True)
        result = subprocess.run(command, check=False)

        report = pathlib.Path(temp) / "check.json"
        if not report.exists():
            if result.returncode != 0:
                sys.exit(f"lua-language-server exited with {result.returncode}")
            results = {}
        else:
            # An empty list when nothing was found.
            results = json.loads(report.read_text(encoding="utf-8")) or {}

    enabled = enabled_paths()
    problems = []
    ignored = 0
    for uri, issues in results.items():
        path = repo_path(uri)
        if not any(path == entry or path.startswith(f"{entry}/") for entry in enabled):
            ignored += len(issues)
            continue

        for issue in issues:
            start = issue["range"]["start"]
            problems.append(
                (
                    path,
                    start["line"] + 1,
                    start["character"] + 1,
                    issue["severity"],
                    issue["code"],
                    issue["message"],
                )
            )
    problems.sort()

    if ignored:
        print(f"Ignored {ignored} problem(s) in modules init.txt doesn't enable.")

    in_actions = os.environ.get("GITHUB_ACTIONS") == "true"
    for path, line, column, severity, code, message in problems:
        print(f"{path}:{line}:{column}: {code}: {message}")
        if in_actions:
            level = ANNOTATIONS.get(severity, "notice")
            print(
                f"::{level} file={escape(path, True)},line={line},col={column},"
                f"title={escape(code, True)}::{escape(message)}"
            )

    summary = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary:
        with open(summary, "a", encoding="utf-8") as out:
            if problems:
                out.write(f"## :x: {len(problems)} problem(s) in modules/\n\n```\n")
                out.writelines(
                    f"{p}:{l}:{c}: {code}: {m}\n" for p, l, c, _, code, m in problems
                )
                out.write("```\n")
            else:
                out.write("## :heavy_check_mark: No problems in modules/\n")

    if problems:
        sys.exit(f"\n{len(problems)} problem(s) in modules/")

    print("No problems in modules/")


if __name__ == "__main__":
    main()
