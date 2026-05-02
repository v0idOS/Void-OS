# StandbyCleaner.ps1
# Flushes the Windows Standby Memory List.
# Uses RtlAdjustPrivilege + NtSetSystemInformation — no ISLC dependency.
# Safe to run on any system at any time.

$engineDir = Join-Path $PSScriptRoot "..\Engine"
Import-Module "$engineDir\Logger.psm1" -ErrorAction SilentlyContinue

Write-VoidLog "Initializing StandbyCleaner..." -Type Info

$code = @"
using System;
using System.Runtime.InteropServices;

public class StandbyFlusher {
    [DllImport("ntdll.dll")] static extern uint RtlAdjustPrivilege(int Privilege, bool Enable, bool CurrentThread, ref bool Enabled);
    [DllImport("ntdll.dll")] static extern uint NtSetSystemInformation(int InfoClass, IntPtr Info, int Length);

    public static string Flush() {
        bool prev = false;
        // SeProfileSingleProcessPrivilege = 13
        uint r1 = RtlAdjustPrivilege(13, true, false, ref prev);
        if (r1 != 0) return "RtlAdjustPrivilege failed: 0x" + r1.ToString("X");

        // SystemMemoryListInformation = 80, MemoryFlushModifiedList = 3
        IntPtr info = Marshal.AllocHGlobal(4);
        Marshal.WriteInt32(info, 4);
        uint r2 = NtSetSystemInformation(80, info, 4);
        Marshal.FreeHGlobal(info);
        if (r2 != 0) return "NtSetSystemInformation failed: 0x" + r2.ToString("X");
        return "OK";
    }
}
"@

try {
    Add-Type -TypeDefinition $code -Language CSharp -ErrorAction Stop
    $result = [StandbyFlusher]::Flush()
    if ($result -eq "OK") {
        Write-VoidLog "StandbyCleaner: Standby memory list flushed successfully." -Type Success
    } else {
        Write-VoidLog "StandbyCleaner: Flush returned error — $result" -Type Error
    }
} catch {
    Write-VoidLog "StandbyCleaner: Failed to compile or execute flush — $($_.Exception.Message)" -Type Error
}
