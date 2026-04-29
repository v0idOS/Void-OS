# Void OS Project Structure

This document describes how the repository is organized and where to make common changes.

## Top-level

- `README.md` - project overview and quick links.
- `docs/` - website and documentation content used for GitHub Pages.
- `src/` - main playbook source.

## `src/`

- `src/void-core/` - core playbook payload and configuration.
  - `Configuration/` - YAML task orchestration and tweak definitions.
    - `Configuration/custom.yml` - root orchestration entry.
    - `Configuration/void/` - core feature groups (`start`, `services`, `components`, etc.).
    - `Configuration/tweaks/` - categorized optional and baseline tweaks.
  - `Executables/` - scripts, registry fragments, themes, images, and utility assets.
  - `playbook.conf` - AME Wizard playbook metadata and UI pages.
- `src/void-tools/` - local build script (`local-build.ps1`) and helper tooling.
- `src/void-packages/` - package manifests for component-level package generation.

## Working conventions

- Keep user-facing branding as `Void OS`.
- Keep technical registry namespace as `VoidOS` for compatibility.
- Prefer adding new tweaks in clearly scoped YAML files and referencing them from a single root.
- Keep scripts idempotent where possible.
