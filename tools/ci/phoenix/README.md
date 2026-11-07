# Phoenix CI

Phoenix uses LSB's GitHub workflows and keeps its own changes to them small, so upstream merges stay easy.
Anything Phoenix-specific lives in this folder or in `.github/workflows/phoenix_checks.yml`.

## Merge conflicts

Each Phoenix edit to an upstream file is wrapped in `Phoenix start: <reason>` and `Phoenix end` comments.
`git grep -n "Phoenix start"` lists them.
If an LSB merge conflicts inside one, take upstream's version and re-apply the lines between the markers.

## Files in this folder

- `run_xi_test.py` runs xi_test with the skip list and the era settings from `setup_tests.py`, so a local run matches CI.
- `xi_test_skips.md` lists the upstream tests CI skips, with the reason for each and the Phoenix test that replaces it.
- `setup_tests.py` removes `modules/init.txt` entries for modules missing from the checkout and sets the era settings for the rest of the job.
- `check_module_lua.py` runs the Lua language server on `modules/`, loading `scripts/` only for its definitions.

Phoenix's replacement tests are in `scripts/tests/phoenix`, and module tests are in `scripts/tests/modules`.

## Module checks

LSB's Lua and data checks only look at `scripts/` and `data/`, so `phoenix_checks.yml` adds two jobs for `modules/`.

- Module Lua runs `check_module_lua.py`, which only flags modules that `modules/init.txt` enables, so unused LSB modules and the rest of the repo stay quiet. It skips phoenix_ac (private) and phoenix_archive.
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

This edit is unmarked because it's meant to go upstream to LSB. Once LSB has it, take its version:

- `codeql_analysis.yml`: runs on `ubuntu-26.04`, whose libdwarf the build can find, and installs the Python packages CMake's codegen needs.

## Repository settings

These are set on GitHub, not in files, so merges can't undo them.

- Settings > Actions > General > Workflow permissions is set to "Read and write permissions". LSB's workflows need it, and with the read-only default the reusable workflows fail to start.
- Tests, Changelog, Publish Meshes and Publish Wiki are disabled in the Actions tab. Tests repeats the PR checks after a merge, and the other three are LSB's publishing jobs, which Phoenix doesn't use.
