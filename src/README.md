# Void OS Core Architecture

Welcome to the Void OS source tree. This directory (`src`) contains the uncompiled, raw modifications, orchestration scripts, and YAML payloads that power the Void OS Master Engine.

## Navigation
- **`void-core`**: The heart of the OS. Contains the AME Wizard orchestration logic (`custom.yml`, `tweaks.yml`), the Desktop toolkit, and the custom PowerShell execution engine.
- **`void-tools`**: Build automation scripts (e.g., `local-build.ps1`) for packing the `.apbx` payload for AME Wizard deployment.

## Development & Building
If you are contributing or modifying the playbook locally, you must use the `local-build.ps1` script to dynamically generate the deployment payload before testing in a VM.

For full development documentation, architectural rules, and rollback procedures, refer to the [Official Documentation](https://github.com/v0idOS/Void-OS/tree/main/docs).