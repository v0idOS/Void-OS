# Contributing to Void OS

Thank you for your interest in contributing to Void OS! We are building an aggressive, uncompromising performance OS, and we welcome code contributions, issue reports, and testing feedback.

## How to Contribute

### 1. Reporting Bugs & Hardware Issues
If you encounter a BSOD, driver failure, or stuttering issue:
1. Ensure you are testing on a clean Windows 11 installation.
2. Open an issue on our [GitHub Issues page](https://github.com/v0idOS/Void-OS/issues).
3. Include your CPU architecture, RAM, and GPU model.
4. If related to latency, provide screenshots of CapFrameX and LatencyMon.

### 2. Suggesting Features
Before submitting a massive architectural change, please open a discussion on our [GitHub Discussions page](https://github.com/v0idOS/Void-OS/discussions). We want to ensure your work aligns with our core philosophy of minimal overhead and zero bloat.

### 3. Submitting Code (Pull Requests)
1. **Fork the repository** to your own GitHub account.
2. **Create a branch** for your feature or fix: `git checkout -b feature/my-tweak`
3. **Write your code.** If you are adding a tweak, ensure it is properly documented and (if necessary) added to the `VoidDesktop` rollback toolbox.
4. **Test your code.** Use `local-build.ps1` to compile an `.apbx` and deploy it on a VM or testing partition.
5. **Submit a PR.** Clearly explain what the code does, why it is necessary, and attach any relevant benchmark improvements.

## Code Style & Guidelines
- **PowerShell:** Keep it clean and well-commented. Avoid aliases (`%`, `?`) in production scripts. Use full cmdlet names.
- **YAML:** Adhere to the AME Wizard spacing and formatting. Do not use tabs.
- **Safety First:** If a tweak modifies critical system state (e.g., IRQs, CPU scheduling), it *must* include conditional logic to verify hardware compatibility (e.g., checking via WMI).

Thank you for making Void OS better!
