"""Prepare a CI checkout for Phoenix's tests.

Drops modules/init.txt entries missing from the checkout, such as private submodules: the servers
log an error for each, which fails the startup checks.

Sets Phoenix's era settings for the rest of the job through GITHUB_ENV: settings/default leaves
every era override off.
"""

import os
import pathlib

MODULES = pathlib.Path(__file__).resolve().parents[3] / "modules"

# WotG and later off, level 75.
ERA = {
    "XI_MAIN_RESTRICT_CONTENT": "1",
    "XI_MAIN_MAX_LEVEL": "75",
    "XI_MAIN_ENABLE_WOTG": "0",
    "XI_MAIN_ENABLE_ACP": "0",
    "XI_MAIN_ENABLE_AMK": "0",
    "XI_MAIN_ENABLE_ASA": "0",
    "XI_MAIN_ENABLE_ABYSSEA": "0",
    "XI_MAIN_ENABLE_SOA": "0",
    "XI_MAIN_ENABLE_ROV": "0",
    "XI_MAIN_ENABLE_TVR": "0",
    "XI_MAIN_ENABLE_VOIDWATCH": "0",
}


def drop_missing_modules():
    init = MODULES / "init.txt"
    kept = []
    for line in init.read_text(encoding="utf-8").splitlines():
        entry = line.strip()
        if entry and not entry.startswith("#") and not (MODULES / entry).exists():
            print(f"Dropping {entry}")
            continue
        kept.append(line)
    init.write_text("\n".join(kept) + "\n", encoding="utf-8")


def set_era():
    env_file = os.environ.get("GITHUB_ENV")
    if not env_file:
        return

    with open(env_file, "a", encoding="utf-8", newline="\n") as out:
        for name, value in ERA.items():
            print(f"{name}={value}")
            out.write(f"{name}={value}\n")


if __name__ == "__main__":
    drop_missing_modules()
    set_era()
