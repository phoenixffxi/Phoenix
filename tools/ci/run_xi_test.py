"""Run xi_test with the arguments given plus the skips listed in xi_test_skips.txt."""

import os
import pathlib
import subprocess
import sys

SKIPS = pathlib.Path(__file__).with_name("xi_test_skips.txt")


def skip_args():
    args = []
    for line in SKIPS.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        flag, pattern = line.split(maxsplit=1)
        args += [flag, pattern]
    return args


def main():
    # Windows does not look in the working directory for a bare program name.
    exe = pathlib.Path.cwd() / ("xi_test.exe" if os.name == "nt" else "xi_test")
    command = [str(exe), *sys.argv[1:], *skip_args()]
    print(" ".join(command), flush=True)
    sys.exit(subprocess.call(command))


if __name__ == "__main__":
    main()
