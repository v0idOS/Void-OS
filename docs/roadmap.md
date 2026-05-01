# Void OS Roadmap

Void OS is rapidly evolving. While our foundation is solid, our ultimate goal is to build an operating system that intelligently adapts to your specific hardware in real-time, removing the need for manual configuration.

## Upcoming Features

### 1. True Hardware AI Detection
Currently, the Void OS Master Engine uses basic WMI querying to prevent dangerous tweaks on incompatible hardware (e.g., blocking ACPI edits on laptops). 

In the future, we are expanding this into a comprehensive "Hardware AI" module that will:
- Check total RAM capacity before disabling system paging (safeguarding 8GB systems).
- Query PCIe bus structures to selectively apply Message Signaled Interrupts (MSI) only to devices that mathematically benefit from it.
- Detect cooling overhead and thermal throttling limits before aggressively unbinding CPU states.

### 2. Dynamic Scheduling Profiles
We plan to introduce dynamic `Win32PrioritySeparation` tuning that shifts in real-time depending on the active foreground application. Instead of locking the OS into a static priority model during deployment, a lightweight background watcher will shift to long, fixed quantums for productivity software and short, variable quantums the moment a recognized game executable is launched.

### 3. Integrated Rollback Environment
Expanding the `VoidDesktop` troubleshooting folder into a full WinPE recovery environment, allowing users to safely rollback aggressive kernel tweaks even if the primary OS becomes unbootable.
