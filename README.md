# Void OS

Void OS is an elite Windows playbook project focused on peak performance, uncompromising privacy, and clean defaults. Built by Batify Lab.

## Links

- Website: https://v0idos.github.io/Void-OS/
- Downloads: https://github.com/v0idOS/Void-OS/releases
- Source: https://github.com/v0idOS/Void-OS
- Issues: https://github.com/v0idOS/Void-OS/issues
- Discussions: https://github.com/v0idOS/Void-OS/discussions

## Project layout

- `src/void-core/` - Core playbook payload, scripts, themes, and configuration.
- `src/void-tools/` - Build helpers (for example `local-build.ps1`).
- `src/void-packages/` - Component package definitions.
- `docs/` - GitHub Pages website and project documentation.

## Build locally

### PowerShell (Windows)

```powershell
Set-Location ".\src\void-core"
..\void-tools\local-build.ps1 -ReplaceOldPlaybook -AddLiveLog -Removals WinverRequirement, Verification -DontOpenPbLocation -FileName "Void OS Test"
```

### Bash

```bash
cd src/void-core
./build-core.sh
```

## Documentation

- [Project Structure](./docs/project-structure.md)
- [Brand Guidelines](./docs/branding.md)
- [Contribution Workflow](./docs/contributing.md)
