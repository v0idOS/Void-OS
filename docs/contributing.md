# Contributing Workflow

This is the practical workflow for contributing to Void OS.

## 1) Create or pick an issue

- Open an issue for bugs or feature requests.
- Keep one issue per logical change.

## 2) Branch and implement

- Branch from `main`.
- Keep changes scoped and reviewable.
- Update docs when behavior changes.

## 3) Validate locally

- Build the playbook with `src/void-tools/local-build.ps1`.
- Test in a VM before testing on a primary machine.
- Record repro steps and expected results.

## 4) Open PR

- Explain *why* the change exists.
- Include test notes.
- Reference related issues.

## 5) Merge and release

- Squash or clean commit history if needed.
- Tag and publish releases with clear notes and checksums.
