"""Drop modules/init.txt entries missing from this checkout"""

import pathlib

MODULES = pathlib.Path(__file__).resolve().parents[2] / "modules"


def main():
    init = MODULES / "init.txt"
    kept = []
    for line in init.read_text(encoding="utf-8").splitlines():
        entry = line.strip()
        if entry and not entry.startswith("#") and not (MODULES / entry).exists():
            print(f"Dropping {entry}")
            continue
        kept.append(line)
    init.write_text("\n".join(kept) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
