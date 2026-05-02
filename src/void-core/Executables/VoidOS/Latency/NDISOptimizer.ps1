$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1" -ErrorAction SilentlyContinue
Import-Module "$engineDir\HardwareDetection.psm1" -ErrorAction SilentlyContinue

Write-VoidLog "Initializing NDIS RSS Optimizer..." -Type Info

if (-not (Test-IsIntelHybridCPU)) {
    Write-VoidLog "Non-Hybrid CPU detected. Skipping RSS E-Core pinning." -Type Skipped
    return
}

try {
    # Dynamically detect P-Cores to find the E-Core offset
    # In Windows, logical processors are listed P-Cores first, then E-Cores.
    $perfCores = (Get-WmiObject -Query "SELECT * FROM Win32_Processor").NumberOfCores
    $logicalProcs = (Get-WmiObject -Query "SELECT * FROM Win32_Processor").NumberOfLogicalProcessors
    
    # Heuristic for Intel Hybrid: P-Cores have HyperThreading, E-Cores do not.
    # Total Logical = (P * 2) + E. Total Physical = P + E.
    # P = Total Logical - Total Physical
    # E = Total Physical - P
    $pCores = $logicalProcs - $perfCores
    $eCores = $perfCores - $pCores
    
    # E-cores start after P-cores' logical processors (P * 2)
    $baseProcessor = $pCores * 2
    
    # Failsafe
    if ($baseProcessor -le 0 -or $eCores -le 0) {
        $baseProcessor = 4; $eCores = 4
    }

    Write-VoidLog "Detected $pCores P-Cores and $eCores E-Cores. Routing RSS starting at Core $baseProcessor..." -Type Info

    Enable-NetAdapterRss -Name "*" -ErrorAction Stop
    Set-NetAdapterRss -Name "*" -BaseProcessorGroup 0 -BaseProcessorNumber $baseProcessor -MaxProcessors $eCores -ErrorAction Stop
    Write-VoidLog "[EXTREME] NDIS Receive Side Scaling pinned to E-Cores dynamically." -Type Success
} catch {
    Write-VoidLog "Failed to configure NDIS RSS: $($_.Exception.Message)" -Type Error
}
