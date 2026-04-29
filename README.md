<div align="center">

# 🌌 Void OS
**The Ultimate Windows Playbook for Unrivaled Performance & Absolute Privacy.**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform: Windows 11](https://img.shields.io/badge/Platform-Windows%2011-0078d7.svg?logo=windows)](https://microsoft.com)
[![Build: AME Wizard](https://img.shields.io/badge/Build-AME%20Wizard-success.svg)](https://ameliorated.io/)
[![Maintainer: Remo](https://img.shields.io/badge/Maintainer-Remo-98c379.svg)](#)

*I am the one who knocks.* Void OS isn't just a debloat script; it is a meticulously engineered, ground-up rewrite of the Windows 11 baseline. Designed for eSports professionals and power users, Void OS rips out the telemetry, destroys the bloat, and injects pure software steroids directly into the kernel architecture.

[**Visit Website**](https://v0idos.github.io/Void-OS/) • [**Download Latest**](https://github.com/v0idOS/Void-OS/releases) • [**Documentation**](./docs/guide.html)

</div>

---

## ⚡ The God-Tier Optimizations

Void OS features exclusive, world-class optimizations that you won't find in standard Windows or generic playbooks:

| Feature | Description | Impact |
|---------|-------------|--------|
| **MPO Destruction** | Permanently disables Multi-Plane Overlay (MPO) at the DWM level. | Eliminates GPU micro-stutters and screen tearing on NVIDIA/AMD cards. |
| **0% Core Parking** | Unhides locked Windows power states and dynamically forces CPU Core Parking to `0%`. | CPU runs at 100% frequency constantly while gaming. No thermal throttling limits. |
| **Game Priority Automator** | Native registry injection that forces eSports titles (`cs2.exe`, `valorant.exe`) to run on **High CPU Priority** automatically. | Massive increases to 1% Low FPS by forcing the CPU to ignore background tasks. |
| **Native Standby Cleaner** | A built-in, silent background task (C# native) that flushes Standby Memory every 10 minutes. | Replaces the need for ISLC. Zero RAM hoarding, zero late-game stutters. |
| **Laptop Battery God** | Dynamically detects AC power states and disables CPU Turbo Boost when unplugged. | Literally **doubles** laptop battery life, instantly snapping back to 100% when plugged in. |

## 🛠️ Project Architecture

Void OS abandons the standard AME playbook structure to forge its own unique identity:

- `src/void-core/` - The beating heart. Core payload, YAML task orchestration, and extreme scripts.
- `src/void-tools/` - The build infrastructure (e.g., `local-build.ps1`).
- `src/void-packages/` - Component package definitions for extreme debloating.
- `docs/` - The $500k GitHub Pages website and project documentation.

## 🚀 How to Build Locally

To build the `.apbx` payload yourself, you must use PowerShell or Bash from the root directory.

### Windows (PowerShell)
```powershell
cd src/void-core
..\void-tools\local-build.ps1 -ReplaceOldPlaybook -AddLiveLog -Removals WinverRequirement, Verification -DontOpenPbLocation -FileName "Void OS Elite"
```

### Linux (Bash)
```bash
cd src/void-core
./build-core.sh
```

## 🤝 Contributing

We welcome pull requests from elite engineers. Before submitting, please ensure your tweaks have been thoroughly benchmarked and do not compromise hardware stability (Wi-Fi/Bluetooth must remain untouched).
- [Contribution Workflow](./docs/contributing.md)
- [Project Structure](./docs/project-structure.md)

## ⚖️ License
This project is protected under the **GPL-3.0 License**. If you modify or distribute Void OS, you must keep your changes open-source and credit Remo. See the [LICENSE](LICENSE) file for details.

<div align="center">
  <sub>Built with relentless dedication by <strong>Remo</strong>.</sub>
</div>
