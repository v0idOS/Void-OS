using System;
using System.IO;
using System.Linq;

namespace VoidControlCenter
{
    public class EngineStatus
    {
        public bool IRQAffinity { get; set; }
        public bool NDISOptimizer { get; set; }
        public bool PCIeASPM { get; set; }
        public bool DynamicPaging { get; set; }
        public bool StandbyCleaner { get; set; }
        public bool ExtremePerformance { get; set; }

        public static EngineStatus Check()
        {
            var status = new EngineStatus();
            string logDir = @"C:\VoidOS_Logs";
            if (!Directory.Exists(logDir)) return status;

            var latestLog = new DirectoryInfo(logDir).GetFiles("Optimization_*.log").OrderByDescending(f => f.CreationTime).FirstOrDefault();
            if (latestLog == null) return status;

            try
            {
                string content = File.ReadAllText(latestLog.FullName);
                status.IRQAffinity = content.Contains("IRQ Affinity Protocol");
                status.NDISOptimizer = content.Contains("NDIS RSS Optimizer");
                status.PCIeASPM = content.Contains("PCIe ASPM Protocol");
                status.DynamicPaging = content.Contains("Dynamic Paging Protocol");
                status.StandbyCleaner = content.Contains("StandbyCleaner"); 
                status.ExtremePerformance = content.Contains("Extreme Performance Protocol Deployed");
            }
            catch { }
            
            return status;
        }
    }
}
