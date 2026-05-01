<#
.SYNOPSIS
Void OS - Extreme Performance Module
.DESCRIPTION
This module forces MSI Mode on critical hardware, annihilates CPU mitigations, uncaps the network, and optimizes the kernel thread scheduler.
.NOTES
Author: v0idOS
#>

function Enable-MSIMode {
    Write-Host "Forcing Message Signaled Interrupts (MSI) on GPU, NVMe, and Network adapters..." -ForegroundColor Cyan
    
    $devices = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\PCI\*\*\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" -ErrorAction SilentlyContinue

    foreach ($device in $devices) {
        $devicePath = $device.PSPath
        Set-ItemProperty -Path $devicePath -Name "MSISupported" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    }
}

function Disable-CPUMitigations {
    Write-Host "Annihilating Spectre & Meltdown CPU Mitigations for maximum IPC..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    Set-ItemProperty -Path $regPath -Name "FeatureSettingsOverride" -Value 3 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "FeatureSettingsOverrideMask" -Value 3 -Type DWord -Force
}

function Optimize-Win32PrioritySeparation {
    Write-Host "Modifying CPU Scheduler for absolute foreground priority (Win32PrioritySeparation 0x26)..." -ForegroundColor Cyan
    
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord -Force
}

function Uncap-NetworkThrottling {
    Write-Host "Uncapping Network Throttling Index for 0-ping multi-player..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    Set-ItemProperty -Path $regPath -Name "NetworkThrottlingIndex" -Value 4294967295 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SystemResponsiveness" -Value 0 -Type DWord -Force
}

function Nuke-HPETandDynamicTicks {
    Write-Host "Nuking HPET, Dynamic Ticks, and forcing 0.5ms hardware timer..." -ForegroundColor Cyan
    
    & bcdedit /set disabledynamictick yes
    & bcdedit /set useplatformclock no
    & bcdedit /set tscsyncpolicy Enhanced
}

# --- Execution Pipeline ---
try {
    Write-Host "--- INITIALIZING VOID OS EXTREME PERFORMANCE ENGINE ---" -ForegroundColor Yellow
    Enable-MSIMode
    Disable-CPUMitigations
    Optimize-Win32PrioritySeparation
    Uncap-NetworkThrottling
    Nuke-HPETandDynamicTicks
    Write-Host "--- EXTREME PERFORMANCE ENGINE DEPLOYED ---" -ForegroundColor Green
} catch {
    Write-Host "Error during Extreme Performance execution: $_" -ForegroundColor Red
}
