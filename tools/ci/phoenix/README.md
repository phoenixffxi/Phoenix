# Phoenix CI

Phoenix uses LSB's GitHub workflows and keeps its own changes to them small, so upstream merges stay easy.
Anything Phoenix-specific lives in this folder or in `.github/workflows/phoenix_checks.yml`.

## Merge conflicts

Each Phoenix edit to an upstream file is wrapped in `Phoenix start: <reason>` and `Phoenix end` comments.
`git grep -n "Phoenix start"` lists them.
If an LSB merge conflicts inside one, take upstream's version and re-apply the lines between the markers.

## Files in this folder

- `run_xi_test.py` runs xi_test with the skip list and the era settings from `setup_tests.py`, so a local run matches CI. It also picks how much to run (see below).
- `xi_test_skips.md` lists the upstream tests CI skips, with the reason for each and the Phoenix test that replaces it.
- `setup_tests.py` removes `modules/init.txt` entries for modules missing from the checkout and sets the era settings for the rest of the job.
- `check_module_lua.py` runs the Lua language server on `modules/`, loading `scripts/` only for its definitions.
- `module_test_coverage.py` checks that every era and phoenix module file `init.txt` enables has a test.
- `module_test_exemptions.md` lists the module files that do nothing under CI's settings, so have no test.

Phoenix's replacement tests are in `scripts/tests/phoenix`, and module tests are in `scripts/tests/modules`.

## Module tests

A module file's test sits at the same path under `scripts/tests/modules`, without the `lua` folder:
`modules/era/lua/combat/tp.lua` is tested by `scripts/tests/modules/era/combat/tp.lua`.
A test can cover other module files by naming each one on a `-- Covers: modules/...` line in its header, which can also name C++ or SQL module files.
Module tests share helpers in `scripts/tests/helpers/modules.lua`, including `assertOverridesApplied`, which fails when an override didn't apply or when the upstream function under it is gone.

Module files that make the same kind of change share one test rather than one test each, for example `scripts/tests/modules/era/actions/weaponskills.lua` for every weapon type.
It lists each file on a `Covers` line, checks all their overrides with `assertCoveredOverridesApplied`, and tests a few representative cases, one for each code path the files go through.
Add a new file of the same kind to the shared test's `Covers` lines rather than giving it its own test.

Each test file has one top-level `describe`, and cases that are slow or check every entry go in a nested `describe` whose title ends in `#exhaustive`.

## How much xi_test runs

- On a pull request whose title contains "update" (the weekly LSB update), on a manual run of Phoenix Checks, and when a PR changes core C++ under `src/`, `xi_test_skips.md` or `setup_tests.py`, everything runs: the upstream tests and every module case.
- On any other pull request only the module tests run, without their `#exhaustive` cases. Tests for the files the PR changes run in full: changed tests, tests covering a changed module file, and tests for modules that override or load a changed `scripts/` file. A change to the test helpers, `modules/init.txt` or `modules/module_utils.lua` runs every module case.
- Upstream tests don't run on those pull requests, even when they change `scripts/`, `data/` or `sql/`. The weekly update PR or a manual run of Phoenix Checks catches what they break.
- Locally, `run_xi_test.py` runs everything unless given `--tier quick`, which needs `--base <ref>` (for example `--base origin/dev`) and counts committed, uncommitted and untracked changes since then.

## Module checks

LSB's Lua and data checks only look at `scripts/` and `data/`, so `phoenix_checks.yml` adds two jobs for `modules/`.

- Module Lua runs `module_test_coverage.py` on every PR, then `check_module_lua.py`, which only flags modules that `modules/init.txt` enables, so unused LSB modules and the rest of the repo stay quiet. It skips phoenix_ac (private) and phoenix_archive.
- Module data runs `tools/ci/validate_module_data.py`, which merges the module data `init.txt` enables onto `data/` and checks the result against the schemas. It also checks the formatting of changed module YAML.

Both also run when `scripts/` or `data/` changes, since an upstream change can break a module.
The data job's schema steps are copied from the Data validation job in `pr_checks.yml`, so copy any upstream change to those steps too.
Lua globals that Phoenix's C++ modules add are declared in `scripts/specs/phoenix/globals.lua`.
`validate_module_data.py` lives in `tools/ci/` rather than here because pylint can only resolve its `tools.codegen` imports from there.

## Edits to upstream files

- `pr_checks.yml`: Build is switched off with `if: false`, which also skips Test.
- `runner_build.yml`: clang-tidy also checks `modules/era` and `modules/phoenix` (with the overrides in `modules/.clang-tidy`).
- `runner_test.yml`: runs `setup_tests.py`, and runs xi_test through `run_xi_test.py` so it skips the tests in `xi_test_skips.md`.
- `build.yml`: also runs on pushes to `beta`, so PRs into beta can reuse its caches.
- `src/test/CMakeLists.txt`: builds the C++ modules into xi_test, so tests run with the same modules as xi_map.
- `tools/ci/sanity_checks/lua_binding_usage.py`: counts module C++ bindings as defined.
- `tools/ci/sanity_checks/git.py`: allows commit titles up to 110 characters, because upstream squash merges add ` (#N)` to titles that were never length-checked.

These edits are unmarked because they're meant to go upstream to LSB. Once LSB has them, take its version:

- `codeql_analysis.yml`: runs on `ubuntu-26.04`, whose libdwarf the build can find, and installs the Python packages CMake's codegen needs.
- `src/test/mock_manager.cpp`: restores stubs and spies newest first, so a path stubbed twice in one case gets its original back.

## Repository settings

These are set on GitHub, not in files, so merges can't undo them.

- Settings > Actions > General > Workflow permissions is set to "Read and write permissions". LSB's workflows need it, and with the read-only default the reusable workflows fail to start.
- Tests, Changelog, Publish Meshes and Publish Wiki are disabled in the Actions tab. Tests repeats the PR checks after a merge, and the other three are LSB's publishing jobs, which Phoenix doesn't use.
