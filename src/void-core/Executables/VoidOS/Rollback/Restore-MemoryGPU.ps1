param([switch]$DryRun)
$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1"

if (-not $DryRun) {
    Enable-MMAgent -mc
    $scheme = (powercfg -getactivescheme).Split(' ')[3]
    powercfg -setacvalueindex $scheme 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a55c20b 1
    powercfg -setactive $scheme
}
Write-VoidLog "[RESTORE] Memory Compression enabled and PCIe ASPM reverted to Moderate Power Savings" -Type Success
