# Known Issues

Void OS pushes Windows 11 to its absolute architectural limits. Due to the diverse nature of PC hardware, you may encounter specific anomalies based on your components.

## 1. Intel Thread Director vs. Extreme Priority Separation
**Affected Hardware:** Intel 12th, 13th, and 14th Gen (Alder Lake / Raptor Lake) CPUs with P-Cores and E-Cores.

**Issue:** Setting `Win32PrioritySeparation` to `0x26` (Short, Variable Quantums) is historically excellent for gaming latency. However, on Intel's hybrid architectures, this can occasionally confuse the hardware-level Thread Director, causing it to bounce active threads rapidly between P-Cores and E-Cores. This manifests as micro-stutters in highly multithreaded games.

**Current Workaround:** The Master Engine now automatically detects Intel Hybrid CPUs and adjusts the priority separation to `0x28` to prevent this behavior. If you still experience issues, please report it via GitHub.

## 2. ACPI Annihilation & Laptops
**Affected Hardware:** All Laptops.

**Issue:** The Void OS "ACPI Annihilation" script forcefully disables specific ACPI Control Method Battery drivers to prevent Windows from polling the hardware constantly, thereby reducing DPC latency spikes. However, doing this on a laptop permanently breaks the battery icon, power management states, and sleep functionality.

**Current Mitigation:** The Master Engine detects laptop chassis types and battery presence, completely bypassing the Experimental ACPI tweaks for mobile users. This feature remains Desktop-only.
