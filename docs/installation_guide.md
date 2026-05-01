# Void OS Installation Guide

Void OS uses AME Wizard to seamlessly debloat and optimize your existing Windows 11 installation. 

## Prerequisites
- A freshly installed, clean version of Windows 11 (24H2 or newer).
- Do not install third-party antiviruses before deploying Void OS.
- Ensure your laptop is plugged in.

## Step 1: Download Requirements
1. Download the latest version of [AME Wizard](https://ameliorated.io/).
2. Download the latest `VoidOS.apbx` release from our [GitHub Releases](https://github.com/v0idOS/Void-OS/releases).

## Step 2: Deployment
1. Extract AME Wizard and launch the executable.
2. Drag and drop the `VoidOS.apbx` file into the AME Wizard UI.
3. The wizard will present you with several options:
    - **Defender:** Choose whether to keep or remove Windows Defender.
    - **Mitigations:** Toggle CPU Spectre/Meltdown mitigations.
    - **Updates:** Configure your Windows Update preference.
4. Click **Next** and allow the playbook to execute. The process will restart Explorer, compile assemblies, and inject the `VoidDesktop` toolkit into your `C:\Windows` directory.
5. Your system will automatically reboot once the deployment and Void OS Master Engine have finished applying the optimizations.

## Step 3: Post-Installation
After rebooting, navigate to your desktop or the `C:\Windows\VoidDesktop` folder. You will find toggles to revert security settings, manage your interface, or restore standard Windows services if necessary.

Enjoy the uncompromising performance of Void OS.
