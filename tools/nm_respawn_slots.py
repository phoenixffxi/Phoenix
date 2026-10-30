"""
Regenerate the slot lists in modules/phoenix/data/zones from core.

A module `slots:` list replaces the core list whole, so each file restates every
slot in its zone with only a few member options changed. Those copies go stale
when an LSB merge edits a zone's slots. This tool copies each zone's current core
slots and reapplies the overrides below, matched by mob name so ID shifts are
picked up. Only the slots section of an existing module file is rewritten.

Usage:
    python tools/nm_respawn_slots.py          # rewrite every module file
    python tools/nm_respawn_slots.py --check  # report stale files, exit 1 if any

Run it after every LSB merge. Add a zone or NM by editing OVERRIDES.
Requires pyyaml and ruamel.yaml (tools/requirements.txt).
"""

import argparse
import importlib.util
import re
import sys
from pathlib import Path

import yaml

ROOT        = Path(__file__).resolve().parents[1]
CORE_ZONES  = ROOT / "data" / "zones"
MODULE_ROOT = ROOT / "modules" / "phoenix" / "data" / "zones"

ERA_SOURCE = "https://forum.square-enix.com/ffxi/threads/38100"

# zone folder -> (header label, { mob name -> slot member options to set })
# Pre-November 5, 2013 lottery cooldowns, from the era old NM respawn timers module.
OVERRIDES = {
    "castle_zvahl_keep": (
        "Baron Vapula, Baronet Romwe and Count Bifrons",
        {
            "Baron_Vapula":  {"cooldown": 7200},
            "Baronet_Romwe": {"cooldown": 7200},
            "Count_Bifrons": {"cooldown": 7200},
        },
    ),
    "feiyin": (
        "N/E/W/S Shadows",
        {
            "Northern_Shadow": {"cooldown": 57600},
            "Eastern_Shadow":  {"cooldown": 57600},
            "Western_Shadow":  {"cooldown": 57600},
            "Southern_Shadow": {"cooldown": 57600},
        },
    ),
    "garlaige_citadel":     ("Hovering Hotpot", {"Hovering_Hotpot": {"cooldown": 5400}}),
    "inner_horutoto_ruins": ("Nocuous Weapon", {"Nocuous_Weapon": {"cooldown": 3600}}),
    "konschtat_highlands":  ("Stray Mary", {"Stray_Mary": {"cooldown": 3600}}),
    "pashhow_marshlands":   ("Bloodpool Vorax", {"Bloodpool_Vorax": {"cooldown": 3600}}),
    "qufim_island":         ("Slippery Sucker", {"Slippery_Sucker": {"cooldown": 3600}}),
    "ranguemont_pass":      ("Hyakume", {"Hyakume": {"cooldown": 3600}}),
    "south_gustaberg":      ("Leaping Lizzy", {"Leaping_Lizzy": {"cooldown": 3600}}),
    "valkurm_dunes":        ("Valkurm Emperor", {"Valkurm_Emperor": {"cooldown": 3600}}),
}

MEMBER_LINE = re.compile(r"^(\s+)(\d+): \{([^}]*)\}(.*)$")


def load_formatter():
    spec   = importlib.util.spec_from_file_location("yaml_format", ROOT / "tools" / "yaml" / "format.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def slots_block(text, what):
    marker = "\nslots:\n"
    start  = text.find(marker)
    if start < 0:
        raise ValueError(f"{what} has no slots section")

    next_section = re.search(r"^[A-Za-z_]+:", text[start + len(marker):], re.MULTILINE)
    end          = len(text)
    if next_section:
        end = start + len(marker) + next_section.start()

    return text[:start + 1], text[start + 1:end], text[end:]


def apply_options(inner, options):
    parsed = {}
    for part in inner.split(","):
        part = part.strip()
        if part:
            key, value = part.split(":", 1)
            parsed[key.strip()] = value.strip()

    for key, value in options.items():
        parsed[key] = str(value)

    return ", ".join(f"{key}: {value}" for key, value in parsed.items())


def build_zone(zone, label, overrides):
    core_path = CORE_ZONES / zone / "mobs.yaml"
    core_text = core_path.read_text(encoding="utf-8")
    spawns    = yaml.safe_load(core_text)["spawns"]
    _, block, _ = slots_block(core_text, core_path)

    names = {}
    for mob_id, spawn in spawns.items():
        names[mob_id] = spawn.get("script") or spawn.get("template")

    applied = set()
    lines   = []
    for line in block.splitlines():
        match = MEMBER_LINE.match(line)
        if match:
            name = names.get(int(match.group(2)))
            if name in overrides:
                inner = apply_options(match.group(3), overrides[name])
                line  = f"{match.group(1)}{match.group(2)}: {{{inner}}}{match.group(4)}"
                applied.add(name)
        lines.append(line)

    missing = sorted(set(overrides) - applied)

    slots       = "\n".join(lines).rstrip("\n") + "\n"
    module_path = MODULE_ROOT / zone / "mobs.yaml"
    comment     = "\n".join([
        f"# Restores the pre-November 5, 2013 lottery cooldown for {label}.",
        f"# Source: {ERA_SOURCE}",
        "# Slots replace the core list whole, so every slot in the zone is restated.",
        "",
    ])

    if not module_path.exists():
        return module_path, comment + "\n" + slots, missing

    module_text = module_path.read_text(encoding="utf-8")
    if "\nslots:\n" not in module_text:
        return module_path, module_text.rstrip("\n") + "\n\n" + comment + slots, missing

    before, _, after = slots_block(module_text, module_path)
    if after:
        slots += "\n"

    return module_path, before + slots + after, missing


def main():
    parser = argparse.ArgumentParser(description="Regenerate nm_respawn slot lists from core.")
    parser.add_argument("--check", action="store_true", help="report stale files without writing")
    args = parser.parse_args()

    formatter = load_formatter()
    stale     = []
    problems  = []

    for zone, (label, overrides) in sorted(OVERRIDES.items()):
        module_path, text, missing = build_zone(zone, label, overrides)
        text = formatter.format_text(text)

        for name in missing:
            problems.append(f"{zone}: {name} is no longer in a core slot")

        current = ""
        if module_path.exists():
            current = module_path.read_text(encoding="utf-8")

        if text == current:
            continue

        stale.append(module_path.relative_to(ROOT))
        if not args.check:
            module_path.parent.mkdir(parents=True, exist_ok=True)
            module_path.write_bytes(text.encode("utf-8"))

    for problem in problems:
        print(f"WARNING: {problem}")

    for path in stale:
        if args.check:
            print(f"stale: {path}")
        else:
            print(f"updated: {path}")

    if not stale:
        print("All nm_respawn slot lists match core.")

    if args.check and (stale or problems):
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
