$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1" -ErrorAction SilentlyContinue

Write-VoidLog "Initializing PCIe ASPM Protocol..." -Type Info

try {
    # 501a4d13-42af-4429-9fd1-a8218c268e20 = PCI Express Settings
    # ee12f906-d277-404b-b6da-e5fa1a576df5 = Link State Power Management
    # 0 = Off
    & powercfg -setacvalueindex SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0
    & powercfg -setdcvalueindex SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0
    & powercfg -setactive SCHEME_CURRENT
    Write-VoidLog "[EXTREME] PCIe Active State Power Management (ASPM) disabled. ACPI DPC latency capped." -Type Success
} catch {
    Write-VoidLog "Failed to disable PCIe ASPM: $($_.Exception.Message)" -Type Error
}
