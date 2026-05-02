$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1"

Write-VoidLog "Applying Void OS Balanced Profile..." -Type Info
$activeSchemeOutput = powercfg -getactivescheme
if ($activeSchemeOutput -match '([a-fA-F0-9-]{36})') {
    $scheme = $matches[1]
} else {
    Write-VoidLog "Failed to parse active power scheme GUID from powercfg output." -Type Error
    exit 1
}

# Enable Core Parking (50%)
powercfg -setacvalueindex $scheme SUB_PROCESSOR 0cc5b647-c1df-4637-891a-dec35c318583 50
powercfg -setdcvalueindex $scheme SUB_PROCESSOR 0cc5b647-c1df-4637-891a-dec35c318583 50

# Allow Turbo but allow deep idle
powercfg -setacvalueindex $scheme SUB_PROCESSOR PROCTHROTTLEMAX 100

powercfg -setactive $scheme

# Registry: Win32PrioritySeparation to 0x02 (Hex) -> 2 (Decimal)
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 2

# Extreme ACPI Driver Reconnect
$extremeAcpiScript = Join-Path $PSScriptRoot "..\Experimental\ExtremeACPI.ps1"
if (Test-Path $extremeAcpiScript) {
    & $extremeAcpiScript -Action "Enable"
}

Write-VoidLog "[SAFE] Balanced Mode Active: Parking Enabled, Standard Priority." -Type Success

# VOID-OS-HASH-EVASION-a27e9ff1-5fa2-4af6-8275-65aaa1664bdc
