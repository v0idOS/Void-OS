# Void OS Native Standby List Cleaner (ISLC Alternative)
# Flushes standby memory to prevent micro-stutters during long gaming sessions.

$source = @"
using System;
using System.Runtime.InteropServices;

public class MemoryCache
{
    [DllImport("ntdll.dll")]
    public static extern int NtSetSystemInformation(int SystemInformationClass, IntPtr SystemInformation, int SystemInformationLength);

    public static void FlushStandby()
    {
        // Require Privilege elevation (assuming SYSTEM or Admin)
        int SYSTEM_MEMORY_LIST_INFORMATION = 80;
        int COMMAND_FLUSH_STANDBY = 4;
        
        try {
            IntPtr pCommand = Marshal.AllocHGlobal(Marshal.SizeOf(COMMAND_FLUSH_STANDBY));
            Marshal.WriteInt32(pCommand, COMMAND_FLUSH_STANDBY);
            NtSetSystemInformation(SYSTEM_MEMORY_LIST_INFORMATION, pCommand, Marshal.SizeOf(COMMAND_FLUSH_STANDBY));
            Marshal.FreeHGlobal(pCommand);
        } catch {}
    }
}
"@

try {
    Add-Type -TypeDefinition $source -Language CSharp
    [MemoryCache]::FlushStandby()
} catch {}
