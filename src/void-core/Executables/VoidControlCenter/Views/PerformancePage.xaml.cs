using System;
using Microsoft.UI.Xaml.Controls;
using Microsoft.Win32;
using VoidControlCenter.Services;

namespace VoidControlCenter.Views
{
    public sealed partial class PerformancePage : Page
    {
        public PerformancePage()
        {
            this.InitializeComponent();
            this.Loaded += (s, e) => LoadStatus();
        }

        private void LoadStatus()
        {
            try
            {
                var key = Registry.LocalMachine.OpenSubKey(
                    @"SYSTEM\CurrentControlSet\Control\PriorityControl");
                var val = key?.GetValue("Win32PrioritySeparation");
                if (val != null)
                {
                    int v = (int)val;
                    txtPriority.Text = $"0x{v:X2} ({(v == 40 ? "Hybrid Mode" : "Classic Mode")})";
                }
            }
            catch (Exception ex)
            {
                HardwareInfo.LogVccError("PerformancePage.LoadStatus", ex);
            }
        }
    }
}
