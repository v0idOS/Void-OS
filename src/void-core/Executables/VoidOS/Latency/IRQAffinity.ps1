$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1" -ErrorAction SilentlyContinue
Import-Module "$engineDir\HardwareDetection.psm1" -ErrorAction SilentlyContinue

Write-VoidLog "Initializing IRQ Affinity Protocol..." -Type Info

if (-not (Test-IsIntelHybridCPU)) {
    Write-VoidLog "Non-Hybrid CPU detected. Skipping specific P/E core mask pinning to avoid thread lockups." -Type Skipped
    return
}

try {
    # GPU Pinning (P-Core 1 -> Mask 0x02)
    $gpuPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\PCI\*\*\Device Parameters\Interrupt Management\Affinity Policy"
    $gpus = Get-ItemProperty -Path $gpuPath -ErrorAction SilentlyContinue | Where-Object { $_.PSPath -match "VEN_10DE|VEN_1002|VEN_8086" }
    
    if ($gpus) {
        foreach ($gpu in $gpus) {
            Set-ItemProperty -Path $gpu.PSPath -Name "AssignmentSetOverride" -Value ([byte[]](0x02,0x00,0x00,0x00)) -Type Binary -ErrorAction SilentlyContinue
        }
        Write-VoidLog "[EXTREME] GPU Interrupts pinned to P-Core 1 (Mask 0x02)." -Type Success
    } else {
        Write-VoidLog "No GPU found for IRQ pinning." -Type Skipped
    }

    # NVMe Pinning (E-Cores -> Mask 0xF0)
    $nvmePath = "HKLM:\SYSTEM\CurrentControlSet\Enum\PCI\*\*\Device Parameters\Interrupt Management\Affinity Policy"
    $nvmes = Get-ItemProperty -Path $nvmePath -ErrorAction SilentlyContinue | Where-Object { $_.PSPath -match "CC_0108" }
    
    if ($nvmes) {
        foreach ($nvme in $nvmes) {
            Set-ItemProperty -Path $nvme.PSPath -Name "AssignmentSetOverride" -Value ([byte[]](0xF0,0x00,0x00,0x00)) -Type Binary -ErrorAction SilentlyContinue
        }
        Write-VoidLog "[EXTREME] NVMe Interrupts pinned to E-Cores (Mask 0xF0)." -Type Success
    }

    # Network Pinning (E-Cores -> Mask 0xF0)
    $netPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\PCI\*\*\Device Parameters\Interrupt Management\Affinity Policy"
    $nets = Get-ItemProperty -Path $netPath -ErrorAction SilentlyContinue | Where-Object { $_.PSPath -match "CC_0200|CC_0280" }
    
    if ($nets) {
        foreach ($net in $nets) {
            Set-ItemProperty -Path $net.PSPath -Name "AssignmentSetOverride" -Value ([byte[]](0xF0,0x00,0x00,0x00)) -Type Binary -ErrorAction SilentlyContinue
        }
        Write-VoidLog "[EXTREME] Network Adapter Interrupts pinned to E-Cores (Mask 0xF0)." -Type Success
    }
} catch {
    Write-VoidLog "Failed to configure IRQ Affinity: $($_.Exception.Message)" -Type Error
}
