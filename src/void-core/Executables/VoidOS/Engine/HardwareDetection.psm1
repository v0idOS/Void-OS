function Get-SystemRAMGB {
    $ram = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    return [math]::Round($ram.Sum / 1GB)
}

function Test-IsLaptop {
    $battery = Get-WmiObject Win32_Battery -ErrorAction SilentlyContinue
    if ($battery) { return $true }
    $chassis = Get-WmiObject Win32_SystemEnclosure
    $laptopTypes = @(8, 9, 10, 11, 12, 14, 18, 21, 31)
    foreach ($type in $chassis.ChassisTypes) {
        if ($laptopTypes -contains $type) { return $true }
    }
    return $false
}

function Test-HasDedicatedGPU {
    $gpus = Get-WmiObject Win32_VideoController
    foreach ($gpu in $gpus) {
        if ($gpu.Name -notmatch "Intel|AMD Radeon\(TM\) Graphics|Microsoft Basic") {
            return $true
        }
    }
    return $false
}

function Test-ServiceExists {
    param([string]$ServiceName)
    $svc = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    return ($null -ne $svc)
}

Export-ModuleMember -Function Get-SystemRAMGB, Test-IsLaptop, Test-HasDedicatedGPU, Test-ServiceExists
