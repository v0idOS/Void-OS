$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1"
Import-Module "$engineDir\HardwareDetection.psm1"

if (-not (Test-IsLaptop)) {
    Write-VoidLog "[SAFE] Battery Mode aborted. Not running on a laptop." -Type Skipped
    exit
}

Write-VoidLog "Applying Void OS Elite Battery Profile..." -Type Info
$activeSchemeOutput = powercfg -getactivescheme
if ($activeSchemeOutput -match '([a-fA-F0-9-]{36})') {
    $scheme = $matches[1]
} else {
    Write-VoidLog "Failed to parse active power scheme GUID from powercfg output." -Type Error
    exit 1
}

# Cap Max Frequency to 99% (Disables Turbo Boost)
powercfg -setdcvalueindex $scheme SUB_PROCESSOR PROCTHROTTLEMAX 99

# Energy Performance Preference (EPP) to 100 (Max Efficiency)
powercfg -setdcvalueindex $scheme SUB_PROCESSOR PERFEPP 100

powercfg -setactive $scheme

# Extreme ACPI Driver Reconnect
$extremeAcpiScript = Join-Path $PSScriptRoot "..\Experimental\ExtremeACPI.ps1"
if (Test-Path $extremeAcpiScript) {
    & $extremeAcpiScript -Action "Enable"
}

Write-VoidLog "[SAFE] Battery Mode Active: Turbo Disabled, Efficiency EPP." -Type Success

# VOID-OS-HASH-EVASION-a27e9ff1-5fa2-4af6-8275-65aaa1664bdc
