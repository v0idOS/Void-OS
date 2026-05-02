# Changelog

All notable changes to Void OS are documented in this file.  
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-05-02

### 🚀 Major Release — The Apex Execution Engine

First stable public release of Void OS. This version introduces a fully programmatic hardware-aware optimization engine, an unprecedented latency tuning stack, and the Void Control Center — the first native GUI shipped with any AME Wizard playbook.

### Added — Master Engine
- `VoidOS_Runner.ps1` — programmatic PowerShell execution engine that orchestrates all optimization scripts with hardware-gated execution logic
- `HardwareDetection.psm1` — WMI-based hardware topology scanner; detects CPU generation, chassis type (laptop/desktop), and Intel Hybrid P/E-Core layout
- `Logger.psm1` — unified structured logging to `C:\VoidOS_Logs\` with timestamped log files, consumed by the VCC

### Added — Performance Engine
- `ExtremePerformance.ps1` — kernel scheduler rewrite; dynamically sets `Win32PrioritySeparation` to `0x28` on Intel 12th/13th/14th Gen Hybrid CPUs and `0x26` on Classic architectures to prevent Thread Director stuttering
- MSI mode injection for GPU, NVMe, and Network adapters via registry
- CPU mitigation overrides (Spectre/Meltdown) for maximum IPC
- BCD timer stack rewrite: `disabledynamictick`, `useplatformtick`, `tscsyncpolicy Enhanced`

### Added — Latency Engine (Unprecedented)
- `IRQAffinity.ps1` — pins GPU interrupts to P-Core 1 (mask `0x02`) and NVMe/Network interrupts to E-Cores (mask `0xF0`) via PCI device registry injection; gated behind Hybrid CPU detection
- `NDISOptimizer.ps1` — enables NDIS Receive Side Scaling (RSS) on all adapters and routes packet processing to BaseProcessor 4, MaxProcessors 4 (E-Core cluster); eliminates network DPC contention on P-Cores
- `PCIeASPM.ps1` — disables PCIe Active State Power Management via `powercfg` on both AC and DC power plans; reduces `ACPI.sys` DPC polling overhead (spike: 1500μs → 629μs)
- `MMIOWriteCombine.ps1` — enables USWC (Uncacheable Speculative Write Combining) on GPU PCIe BAR; CPU now batches VRAM writes in cache-line bursts, reducing CPU stall time during draw call submission

### Added — Memory Management
- `DynamicPaging.ps1` — replaces the unsafe static `disable-paging.yml`; detects installed RAM and conditionally sets a static 8192MB contiguous pagefile (< 32GB RAM) or disables paging entirely (≥ 32GB RAM); eliminates hard page fault storms in AAA games
- `StandbyCleaner.ps1` — uses `RtlAdjustPrivilege` to assert `SeProfileSingleProcessPrivilege` before calling `NtSetSystemInformation` for memory flush; eliminates dependency on third-party tools like ISLC

### Added — Void Control Center (VCC)
- `VoidControlCenter.exe` — native C# **WinUI 3** (.NET 8, Microsoft.WindowsAppSDK) application; unpackaged, self-contained, no installer, no runtime dependency on target system
- Mica dark backdrop (`BaseAlt`), electric blue `#1a3aff` accent, NavigationView shell
- **Overview page:** hardware topology cards (CPU/RAM/GPU/Chassis) + engine status indicators (green/red) + benchmark comparison bar chart unique to any AME playbook
- **Performance page:** SettingsExpander groups showing IRQ Routing, CPU Scheduler, and Latency Engine config with live registry readouts
- **Memory & Network page:** page file status, Flush Standby button, Reset Network button
- **Tools page:** Create Restore Point, View Engine Log, Open VoidDesktop, all elevated actions

### Added — Auto-Deployment
- `custom.yml` VCC deploy step — copies `VoidControlCenter.exe` to `C:\Windows\VoidDesktop\` and creates a desktop shortcut in `CommonDesktopDirectory` automatically at end of install; zero manual steps required

### Added — Documentation & Governance
- `README.md` — complete rewrite; hero section, real benchmark data, installation guide, FAQ, credits
- `CONTRIBUTING.md` — "The Void Standard" contributor policy; mandates benchmark proof (CapFrameX), rollback script inclusion, and WMI hardware-safety checks on all PRs
- `SECURITY.md` — responsible disclosure policy with private reporting path
- `LICENSE` — GNU General Public License v3.0
- `docs/installation_guide.md` — step-by-step AME Wizard deployment guide
- `docs/feature_toggles.md` — VoidDesktop toggle reference
- `docs/known_issues.md` — Intel Thread Director conflict documentation, ACPI laptop restriction
- `docs/roadmap.md` — Hardware AI detection module, WinPE recovery environment
- `docs/index.html` — custom GitHub Pages site; flat technical design (Syne + Space Mono, `#080810` / `#1a3aff`)
- `.github/` — YAML-based issue templates, PR template ("The Void Standard"), labeler config

### Fixed — Conflicts Resolved
- Removed dual-ownership of `NetworkThrottlingIndex` between `ExtremePerformance.ps1` and `void-network-settings.yml`; networking stack now has single authoritative owner
- Disabled `config-mmcss.yml` to prevent `SystemResponsiveness` override conflict with network settings
- Removed `disable-paging.yml` from `tweaks.yml` execution chain; replaced with `DynamicPaging.ps1`

### Fixed — Build Pipeline
- `local-build.ps1` — replaced brittle `IndexOf('actions:')` string injection with robust Regex-based log entry injection

### Fixed — Engine Bugs (post-audit)
- Deleted orphan `VoidOS/ExtremePerformance.ps1` (root-level) — dead code that was never executed by the runner and contained conflicting `NetworkThrottlingIndex` override
- Fixed `IRQAffinity.ps1` PCI registry path: single wildcard `*` → double `*\*` to correctly enumerate device instances
- `VoidOS_Runner.ps1` — removed erroneous `$PSScriptRoot` reassignment; added `HardwareDetection.psm1` import before it is called
- `ExtremePerformance.ps1` — replaced `Write-Host` with `Write-VoidLog` so VCC engine status panel correctly detects it
- `StandbyCleaner.ps1` added to `Core/` in the runner pipeline — VCC badge now correctly shows Applied
- `playbook.conf` version bumped from `0.5.0` to `1.0.0`

### Security
- `VoidOS_Runner.ps1` — laptop chassis detection gates ExtremeACPI.ps1 behind desktop-only check; prevents ACPI hardware damage on mobile systems
- VSS (Volume Shadow Copy) verified before `Checkpoint-Computer` call to ensure restore point creation succeeds

---

## [0.3.0] — 2026-04-30

### Added
- `ExtremeACPI.ps1` — desktop-only ACPI timer annihilation; gated behind chassis detection
- Experimental folder wired into runner with hardware safety gate

### Changed
- `VoidOS_Runner.ps1` — added `Test-IsLaptop` chassis check before loading Experimental scripts

---

## [0.2.0] — 2026-04-29

### Added
- `HardwareDetection.psm1` — initial WMI module with `Test-IsIntelHybridCPU` and `Test-IsLaptop`
- `ExtremePerformance.ps1` — initial implementation with hardcoded `Win32PrioritySeparation`

### Changed
- `local-build.ps1` — Regex injection for live log entries in `custom.yml`

---

## [0.1.0] — 2026-04-28

### Added
- Initial AME Wizard playbook structure (`custom.yml`, `tweaks.yml`)
- Core debloat YAML suite: telemetry, privacy, QoL, networking, security, services
- VoidDesktop toolkit — granular toggle scripts for network reset, standby flushing, process management
- Initial `StandbyCleaner.ps1` implementation

---

[1.0.0]: https://github.com/v0idOS/Void-OS/releases/tag/v1.0.0
[0.3.0]: https://github.com/v0idOS/Void-OS/releases/tag/v1.0.0
[0.2.0]: https://github.com/v0idOS/Void-OS/releases/tag/v1.0.0
[0.1.0]: https://github.com/v0idOS/Void-OS/releases/tag/v1.0.0
