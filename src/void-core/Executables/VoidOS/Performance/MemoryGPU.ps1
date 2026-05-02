param([switch]$DryRun)
$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1"
Import-Module "$engineDir\HardwareDetection.psm1"

$ramGB = Get-SystemRAMGB
if ($ramGB -ge 16) {
    if (-not $DryRun) { Disable-MMAgent -mc }
    Write-VoidLog "[MODERATE] Memory Compression disabled (System has $ramGB GB RAM)" -Type Success
} else {
    Write-VoidLog "[MODERATE] Memory Compression retained (Insufficient RAM: $ramGB GB)" -Type Skipped
}

if (Test-HasDedicatedGPU) {
    if (-not $DryRun) {
        $scheme = (powercfg -getactivescheme).Split(' ')[3]
        powercfg -setacvalueindex $scheme 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0
        powercfg -setdcvalueindex $scheme 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 2
        powercfg -setactive $scheme
    }
    Write-VoidLog "[MODERATE] PCIe ASPM disabled for Dedicated GPU" -Type Success
} else {
    Write-VoidLog "[MODERATE] PCIe ASPM retained (No Dedicated GPU found)" -Type Skipped
}
