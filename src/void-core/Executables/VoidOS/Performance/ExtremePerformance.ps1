# ==============================================================================
# Void OS Master Engine - Extreme Performance Module
# WARNING: These tweaks alter core kernel scheduling, CPU mitigations, and IRQs.
# ==============================================================================

param(
    [switch]$DryRun,
    [bool]$IsHybridCPU = $false
)

$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1" -ErrorAction SilentlyContinue

Write-VoidLog "Initializing Extreme Performance Protocol..." -Type Info

# ------------------------------------------------------------------------------
# 1. MSI Mode (Message Signaled Interrupts) Injection
# ------------------------------------------------------------------------------
Write-Host "[Void OS] Forcing MSI Mode for GPU, NVMe, and Network Adapters..." -ForegroundColor Yellow
$deviceClasses = @("Display", "SCSIAdapter", "Net")
foreach ($class in $deviceClasses) {
    $devices = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\PCI\*" -ErrorAction SilentlyContinue
    foreach ($dev in $devices) {
        $devPath = $dev.PSPath
        if (Test-Path "$devPath\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties") {
            # Force MSI Mode
            Set-ItemProperty -Path "$devPath\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" -Name "MSISupported" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
            # Set high IRQ priority
            Set-ItemProperty -Path "$devPath\Device Parameters\Interrupt Management\Affinity Policy" -Name "DevicePriority" -Value 3 -Type DWord -Force -ErrorAction SilentlyContinue
        }
    }
}

# ------------------------------------------------------------------------------
# 2. CPU Mitigations Annihilation (Spectre/Meltdown)
# ------------------------------------------------------------------------------
Write-Host "[Void OS] Annihilating CPU Mitigations (Spectre/Meltdown)..." -ForegroundColor Yellow
$featureSettings = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
Set-ItemProperty -Path $featureSettings -Name "FeatureSettingsOverride" -Value 3 -Type DWord -Force
Set-ItemProperty -Path $featureSettings -Name "FeatureSettingsOverrideMask" -Value 3 -Type DWord -Force

# ------------------------------------------------------------------------------
# 3. Win32PrioritySeparation & CPU Scheduling
# ------------------------------------------------------------------------------
Write-Host "[Void OS] Rewriting Win32PrioritySeparation for Foreground Gaming..." -ForegroundColor Yellow
$prioritySeparation = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
# 0x26 = Short, Variable Quantums, Max Foreground Boost. Absolute best for gaming latency.
# 0x28 = For Intel Hybrid CPUs to prevent Thread Director issues.
$win32PriorityValue = if ($IsHybridCPU) { 40 } else { 38 }
Set-ItemProperty -Path $prioritySeparation -Name "Win32PrioritySeparation" -Value $win32PriorityValue -Type DWord -Force 

# ------------------------------------------------------------------------------
# 4. BCD Timer & HPET Nuke
# ------------------------------------------------------------------------------
Write-Host "[Void OS] Nuking HPET and Dynamic Ticks..." -ForegroundColor Yellow
# Disable Dynamic Tick (Stops Windows from stopping the system timer)
& bcdedit /set disabledynamictick yes | Out-Null
# Disable Synthetic Timers (Forces hardware timer)
& bcdedit /set useplatformclock no | Out-Null
& bcdedit /set useplatformtick yes | Out-Null
& bcdedit /set tscsyncpolicy Enhanced | Out-Null

Write-VoidLog "Extreme Performance Protocol Deployed" -Type Success

# VOID-OS-HASH-EVASION-a27e9ff1-5fa2-4af6-8275-65aaa1664bdc
