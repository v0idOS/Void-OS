$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1" -ErrorAction SilentlyContinue
Import-Module "$engineDir\HardwareDetection.psm1" -ErrorAction SilentlyContinue

Write-VoidLog "Initializing NDIS RSS Optimizer..." -Type Info

if (-not (Test-IsIntelHybridCPU)) {
    Write-VoidLog "Non-Hybrid CPU detected. Skipping RSS E-Core pinning." -Type Skipped
    return
}

try {
    Enable-NetAdapterRss -Name "*" -ErrorAction Stop
    # 4P+4E configuration: Base processor 4, max 4 processors (E-Cores)
    Set-NetAdapterRss -Name "*" -BaseProcessorGroup 0 -BaseProcessorNumber 4 -MaxProcessors 4 -ErrorAction Stop
    Write-VoidLog "[EXTREME] NDIS Receive Side Scaling pinned to E-Cores successfully." -Type Success
} catch {
    Write-VoidLog "Failed to configure NDIS RSS: $($_.Exception.Message)" -Type Error
}
