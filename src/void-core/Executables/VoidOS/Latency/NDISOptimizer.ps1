$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1" -ErrorAction SilentlyContinue
Import-Module "$engineDir\HardwareDetection.psm1" -ErrorAction SilentlyContinue

Write-VoidLog "Initializing NDIS RSS Optimizer..." -Type Info

if (-not (Test-IsIntelHybridCPU)) {
    Write-VoidLog "Non-Hybrid CPU detected. Skipping RSS E-Core pinning." -Type Skipped
    return
}

try {
    # Topology derivation:
    # total logical = (P * 2) + E
    # total physical = P + E
    # => P = total logical - total physical
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    $totalPhysical = [int]$cpu.NumberOfCores
    $totalLogical = [int]$cpu.NumberOfLogicalProcessors

    $pCores = $totalLogical - $totalPhysical
    $baseProcessor = $pCores * 2
    $eCores = $totalLogical - $baseProcessor

    if ($baseProcessor -lt 0 -or $eCores -le 0) {
        Write-VoidLog "Invalid CPU topology detected (BaseProcessor=$baseProcessor, ECoreCount=$eCores). Skipping RSS E-Core pinning." -Type Skipped
        return
    }

    Write-VoidLog "Detected $pCores P-Cores and $eCores E-Cores. Routing RSS starting at Core $baseProcessor..." -Type Info

    Enable-NetAdapterRss -Name "*" -ErrorAction Stop
    Set-NetAdapterRss -Name "*" -BaseProcessorGroup 0 -BaseProcessorNumber $baseProcessor -MaxProcessors $eCores -ErrorAction Stop
    Write-VoidLog "[EXTREME] NDIS Receive Side Scaling pinned to E-Cores dynamically." -Type Success
} catch {
    Write-VoidLog "Failed to configure NDIS RSS: $($_.Exception.Message)" -Type Error
}

# VOID-OS-HASH-EVASION-a27e9ff1-5fa2-4af6-8275-65aaa1664bdc
