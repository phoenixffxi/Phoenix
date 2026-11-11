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

Phoenix's replacement tests are in `scripts/tests/phoenix`, and module tests are in `scripts/tests/modules`.

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
