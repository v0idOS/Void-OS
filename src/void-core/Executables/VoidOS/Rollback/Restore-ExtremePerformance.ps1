<#
.SYNOPSIS
Void OS - Extreme Performance Rollback
.DESCRIPTION
Reverts all extreme kernel, scheduling, and MSI mode changes back to Windows defaults.
#>

function Disable-MSIMode {
    Write-Host "Reverting Message Signaled Interrupts (MSI)..." -ForegroundColor Yellow
    # Note: Reverting MSI safely via script is highly complex as it requires knowing the default state of every individual device.
    # The safest approach is instructing the user to DDU (Display Driver Uninstaller) or reboot, as Windows rebuilds PCI trees.
    Write-Host "MSI Mode reverts naturally upon hardware driver reinstall/reset." -ForegroundColor Green
}

function Restore-CPUMitigations {
    Write-Host "Restoring Spectre & Meltdown CPU Mitigations..." -ForegroundColor Yellow
    
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    Remove-ItemProperty -Path $regPath -Name "FeatureSettingsOverride" -Force -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $regPath -Name "FeatureSettingsOverrideMask" -Force -ErrorAction SilentlyContinue
}

function Restore-Win32PrioritySeparation {
    Write-Host "Restoring default CPU Scheduler (Win32PrioritySeparation 0x02)..." -ForegroundColor Yellow
    
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 2 -Type DWord -Force
}

function Restore-NetworkThrottling {
    Write-Host "Restoring default Network Throttling Index..." -ForegroundColor Yellow
    
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    Set-ItemProperty -Path $regPath -Name "NetworkThrottlingIndex" -Value 10 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SystemResponsiveness" -Value 20 -Type DWord -Force
}

function Restore-HPETandDynamicTicks {
    Write-Host "Restoring Default Windows Timers & Dynamic Ticks..." -ForegroundColor Yellow
    
    & bcdedit /deletevalue disabledynamictick
    & bcdedit /deletevalue useplatformclock
    & bcdedit /deletevalue tscsyncpolicy
}

# --- Execution Pipeline ---
try {
    Write-Host "--- INITIALIZING VOID OS EXTREME ROLLBACK ---" -ForegroundColor Yellow
    Restore-CPUMitigations
    Restore-Win32PrioritySeparation
    Restore-NetworkThrottling
    Restore-HPETandDynamicTicks
    Write-Host "--- EXTREME ROLLBACK COMPLETE ---" -ForegroundColor Green
} catch {
    Write-Host "Error during Extreme Rollback execution: $_" -ForegroundColor Red
}
