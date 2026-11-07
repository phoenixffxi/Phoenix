"""Run xi_test with the arguments given plus the skips listed in xi_test_skips.md."""

import os
import pathlib
import re
import subprocess
import sys

from setup_tests import ERA

SKIPS = pathlib.Path(__file__).with_name("xi_test_skips.md")


# Each list item that is only a code span is a pattern to skip.
def skip_args():
    args = []
    for line in SKIPS.read_text(encoding="utf-8").splitlines():
        match = re.fullmatch(r"- `([^`]+)`", line.strip())
        if match:
            args += ["--no-filter", match.group(1)]
    return args


def main():
    # Windows does not look in the working directory for a bare program name.
    exe = pathlib.Path.cwd() / ("xi_test.exe" if os.name == "nt" else "xi_test")
    command = [str(exe), *sys.argv[1:], *skip_args()]
    print(" ".join(command), flush=True)

    # The era settings CI uses, unless the environment already sets them.
    sys.exit(subprocess.call(command, env={**ERA, **os.environ}))


if __name__ == "__main__":
    main()
