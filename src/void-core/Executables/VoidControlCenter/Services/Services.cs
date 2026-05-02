using System;
using System.IO;
using System.Management;

namespace VoidControlCenter.Services
{
    public class HardwareInfo
    {
        public static void LogVccError(string source, Exception ex)
        {
            var logDir = @"C:\VoidOS_Logs";
            Directory.CreateDirectory(logDir);
            var line = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] [{source}] {ex.Message}{Environment.NewLine}";
            File.AppendAllText(Path.Combine(logDir, "VCC_Errors.log"), line);
        }

        public string CpuName { get; set; } = "Unknown";
        public string CpuArch { get; set; } = "Classic";
        public string RamAmount { get; set; } = "Unknown";
        public string GpuName { get; set; } = "Unknown";
        public string Chassis { get; set; } = "Desktop";
        public bool IsHybrid { get; set; } = false;
        public bool IsLaptop { get; set; } = false;

        public static HardwareInfo Detect()
        {
            var info = new HardwareInfo();
            try
            {
                using var cpuQ = new ManagementObjectSearcher("SELECT Name FROM Win32_Processor");
                foreach (var o in cpuQ.Get())
                {
                    info.CpuName = o["Name"]?.ToString()?.Trim() ?? "Unknown CPU";
                    if (info.CpuName.Contains("12th Gen") || info.CpuName.Contains("13th Gen") ||
                        info.CpuName.Contains("14th Gen") || info.CpuName.Contains("Core Ultra"))
                    {
                        info.CpuArch = "Hybrid (P+E Core)";
                        info.IsHybrid = true;
                    }
                    break;
                }

                long totalBytes = 0;
                using var ramQ = new ManagementObjectSearcher("SELECT Capacity FROM Win32_PhysicalMemory");
                foreach (var o in ramQ.Get()) totalBytes += Convert.ToInt64(o["Capacity"]);
                info.RamAmount = $"{totalBytes / (1024 * 1024 * 1024)} GB";

                using var gpuQ = new ManagementObjectSearcher("SELECT Name FROM Win32_VideoController");
                foreach (var o in gpuQ.Get()) { info.GpuName = o["Name"]?.ToString() ?? "Unknown GPU"; break; }

                using var cQ = new ManagementObjectSearcher("SELECT ChassisTypes FROM Win32_SystemEnclosure");
                foreach (var o in cQ.Get())
                {
                    if (o["ChassisTypes"] is ushort[] t && t.Length > 0)
                    {
                        if (t[0] == 9 || t[0] == 10 || t[0] == 14)
                        { info.Chassis = "Laptop"; info.IsLaptop = true; }
                    }
                }
            }
            catch (Exception ex)
            {
                LogVccError("HardwareInfo.Detect", ex);
            }
            return info;
        }
    }

    public class EngineStatus
    {
        public bool IRQAffinity { get; set; }
        public bool NDISOptimizer { get; set; }
        public bool PCIeASPM { get; set; }
        public bool DynamicPaging { get; set; }
        public bool StandbyCleaner { get; set; }
        public bool ExtremePerformance { get; set; }
        public string LastLogDate { get; set; } = "Never";

        public static EngineStatus Check()
        {
            var s = new EngineStatus();
            var logDir = @"C:\VoidOS_Logs";
            if (!System.IO.Directory.Exists(logDir)) return s;
            var logs = new System.IO.DirectoryInfo(logDir).GetFiles("Optimization_*.log");
            if (logs.Length == 0) return s;
            System.Array.Sort(logs, (a, b) => b.CreationTime.CompareTo(a.CreationTime));
            var latest = logs[0];
            s.LastLogDate = latest.CreationTime.ToString("yyyy-MM-dd HH:mm");
            try
            {
                var c = System.IO.File.ReadAllText(latest.FullName);
                s.IRQAffinity      = c.Contains("IRQ Affinity Protocol");
                s.NDISOptimizer    = c.Contains("NDIS RSS Optimizer");
                s.PCIeASPM         = c.Contains("PCIe ASPM Protocol");
                s.DynamicPaging    = c.Contains("Dynamic Paging Protocol");
                s.StandbyCleaner   = c.Contains("StandbyCleaner");
                s.ExtremePerformance = c.Contains("Extreme Performance Protocol Deployed");
            }
            catch (Exception ex)
            {
                HardwareInfo.LogVccError("EngineStatus.Check", ex);
            }
            return s;
        }
    }
}
