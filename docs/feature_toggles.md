# Feature Toggles (VoidDesktop)

One of the defining features of Void OS is giving control back to the power user. 

Unlike other performance playbooks that permanently strip functionality, Void OS injects the `VoidDesktop` toolkit directly into `C:\Windows\VoidDesktop` (and leaves a shortcut on your desktop).

## How to Use the Toggles
Inside the `VoidDesktop` folder, you will find categorized `.cmd` and `.ps1` scripts. Simply double-click a script to execute it. Most scripts provide instant feedback and will require administrator privileges.

### Key Categories

#### 1. Software & Browsers
Easily install recommended, privacy-respecting software or web browsers without touching the Microsoft Store.

#### 2. Drivers
Tools like Display Driver Uninstaller (DDU) and NVCleanInstall are linked directly to help you strip bloat from your GPU drivers.

#### 3. General Configuration
- **Timer Resolution:** Toggle or configure the timer resolution for lowered input lag.
- **Standby Memory:** Manually flush your standby list using our native `StandbyCleaner.ps1` implementation (a lightweight alternative to ISLC).

#### 4. Interface Tweaks
Quickly modify the taskbar, restore the classic context menu, or manage shortcut icons.
> **Note:** Removing the shortcut icon overlay entirely can pose a minor security risk, as malware can disguise `.lnk` payloads. A warning is provided on this specific toggle.

#### 5. Windows Settings & Security
Lost access to a specific Windows feature? Use the toggles here to temporarily unhide the Windows Update page, or manage Defender configurations post-install.

#### 9. Troubleshooting (Rollback)
If Void OS optimizations cause instability on your specific hardware configuration, you can use the Restore scripts located here to gracefully roll back the Master Engine's tweaks.
