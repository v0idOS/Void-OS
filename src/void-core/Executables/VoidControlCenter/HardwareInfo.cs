using System;
using System.Management;

namespace VoidControlCenter
{
    public class HardwareInfo
    {
        public string CpuName { get; set; } = "Unknown CPU";
        public string CpuArchitecture { get; set; } = "Classic Architecture";
        public string RamAmount { get; set; } = "Unknown RAM";
        public string GpuName { get; set; } = "Unknown GPU";
        public string ChassisType { get; set; } = "Desktop";

        public static HardwareInfo Detect()
        {
            var info = new HardwareInfo();
            try
            {
                using (var searcher = new ManagementObjectSearcher("select Name from Win32_Processor"))
                {
                    foreach (var obj in searcher.Get())
                    {
                        info.CpuName = obj["Name"]?.ToString() ?? "Unknown CPU";
                        if (info.CpuName.Contains("12th Gen") || info.CpuName.Contains("13th Gen") || info.CpuName.Contains("14th Gen") || info.CpuName.Contains("Core Ultra"))
                        {
                            info.CpuArchitecture = "Hybrid (P-Core / E-Core)";
                        }
                        break;
                    }
                }

                using (var searcher = new ManagementObjectSearcher("select Capacity from Win32_PhysicalMemory"))
                {
                    long totalBytes = 0;
                    foreach (var obj in searcher.Get())
                    {
                        totalBytes += Convert.ToInt64(obj["Capacity"]);
                    }
                    info.RamAmount = $"{totalBytes / (1024 * 1024 * 1024)} GB";
                }

                using (var searcher = new ManagementObjectSearcher("select Name from Win32_VideoController"))
                {
                    foreach (var obj in searcher.Get())
                    {
                        info.GpuName = obj["Name"]?.ToString() ?? "Unknown GPU";
                        break;
                    }
                }

                using (var searcher = new ManagementObjectSearcher("select ChassisTypes from Win32_SystemEnclosure"))
                {
                    foreach (var obj in searcher.Get())
                    {
                        ushort[] types = (ushort[])obj["ChassisTypes"];
                        if (types != null && types.Length > 0)
                        {
                            int type = types[0];
                            if (type == 9 || type == 10 || type == 14)
                                info.ChassisType = "Laptop / Mobile Chassis";
                        }
                    }
                }
            }
            catch { }
            return info;
        }
    }
}
