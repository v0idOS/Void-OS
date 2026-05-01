<div align="center">
  <h1>Void OS</h1>
  <p><strong>A modular, debloated, high-performance execution engine for Windows 11.</strong></p>
  <a href="https://github.com/v0idOS/Void-OS/releases">Download Latest Release</a>
  <br />
  <br />
  <img src="https://img.shields.io/badge/Platform-Windows%2011-0078d7.svg?logo=windows" alt="Platform" />
  <img src="https://img.shields.io/badge/License-GPLv3-blue.svg" alt="License" />
  <img src="https://img.shields.io/badge/Build-AME%20Wizard-success.svg" alt="Build Status" />
</div>

<hr />

## What is Void OS?
Void OS is not a custom ISO. It is a highly aggressive, modular deployment playbook that completely strips telemetry, unbinds unnecessary Windows background services, and rewrites the core scheduler to prioritize absolute foreground execution and low DPC latency. 

Inspired by AtlasOS and ReviOS, but built with a custom programmatic engine to enforce uncompromising performance.

## Core Features
- **Uncompromised Scheduling:** Rewrites `Win32PrioritySeparation` dynamically to favor foreground tasks and tighten 0.1% lows during intensive workloads.
- **Aggressive Debloating:** Purges Windows telemetry, unnecessary background applications, diagnostic tracking, and forced Defender scans via an automated AME Wizard deployment.
- **Power User Desktop Toolbox:** Drops `VoidDesktop` and `VoidModules` straight onto your C:\ drive, giving you granular toggles to revert security settings, manage interface tweaks, and safely roll back aggressive registry modifications at any time.
- **Service Annihilation:** Force-disables `SysMain`, `DPS`, and heavily caps network throttling for latency-sensitive network environments.

---

## Benchmarks

*Hardware: Intel Core i5-12450HX (4P+4E) / RTX 3050 6GB Mobile / 16GB RAM*
*Context: The Last of Us Part I (High Settings + DLSS Quality @ 144Hz)*

| Operating System | Avg FPS | 1% Low | 0.1% Low | Avg DPC (μs) | Worst Spike (μs) |
|------------------|---------|--------|----------|----------------------|----------------------|
| **Stock Windows 11 (Est)**| ~55.0   | ~38.0  | ~24.0    | ~200.0               | >1500.0 (dxgkrnl)    |
| **Void OS (Current)** | 67.3    | 55.7   | 48.3     | 47.9                 | 629.0 (ACPI.sys)     |
| **Void OS (Projected Phase 1)**| 68.5    | 59.0   | 53.5     | <30.0                | ~300.0               |

> **The Void Difference:** Void OS is currently delivering a **~22% increase in Average FPS**, a **~46% increase in 1% Lows**, and an unprecedented **~100% improvement in 0.1% Lows**. Stutter events have been entirely eradicated.

---

## Installation

> [!WARNING]
> Installing Void OS makes deep, permanent changes to your Windows environment. We strongly recommend installing Void OS on a **clean, freshly installed** version of Windows 11.

1. **Download AME Wizard:** Ensure you have the latest [AME Wizard](https://ameliorated.io/) ready.
2. **Download the Void OS Playbook:** Grab the `.apbx` file from the [Releases](https://github.com/v0idOS/Void-OS/releases) page.
3. **Execute:** Run AME Wizard, drag and drop the `.apbx` file, and follow the setup prompts.

For a comprehensive guide, please refer to our [Installation Guide](https://github.com/v0idOS/Void-OS/tree/main/docs/installation_guide.md).

---

## Documentation
- [Installation Guide](https://github.com/v0idOS/Void-OS/tree/main/docs/installation_guide.md)
- [Feature Toggles (VoidDesktop)](https://github.com/v0idOS/Void-OS/tree/main/docs/feature_toggles.md)
- [Known Issues](https://github.com/v0idOS/Void-OS/tree/main/docs/known_issues.md)
- [Roadmap](https://github.com/v0idOS/Void-OS/tree/main/docs/roadmap.md)

---

## Frequently Asked Questions (FAQ)

**Is this an ISO file?**  
No. Void OS uses AME Wizard to modify your existing Windows installation natively. This ensures your OS maintains driver compatibility.

**Can I undo this?**  
Void OS attempts to create a System Restore point prior to the aggressive execution phase. We also ship `VoidDesktop` to your system which contains direct reversal scripts for many of our tweaks.

**Will I get banned in multiplayer games?**  
Void OS disables specific Windows security features for performance gains, but it does **not** tamper with game memory or anti-cheat clients (like Vanguard, EAC, or BattlEye). It is generally safe, though playing at your own risk is always advised.

---

## Credits & Acknowledgements
Void OS utilizes tools and scripts from the following exceptional open-source projects:
- [AME Wizard](https://ameliorated.io/) - The core deployment engine.
- [TimerResolution](https://github.com/deaglebullet/TimerResolution) - By deaglebullet.
- [ViVeTool](https://github.com/thebookisclosed/ViVe) - By thebookisclosed.
- [SetSvc](https://github.com/he3als/setSvc) - By he3als.

## License
Void OS is licensed under the [GNU General Public License v3.0](LICENSE).
