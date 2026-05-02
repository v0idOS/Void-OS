using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Threading.Tasks;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;

namespace VoidControlCenter.Views
{
    public sealed partial class ToolsPage : Page
    {
        public ToolsPage() { this.InitializeComponent(); }

        private async void BtnFlush_Click(object sender, RoutedEventArgs e)
        {
            btnFlush.IsEnabled = false;
            try
            {
                var script = Path.Combine(Environment.GetEnvironmentVariable("windir")!, "VoidDesktop", "StandbyCleaner.ps1");
                var p = Process.Start(new ProcessStartInfo
                {
                    FileName = "powershell.exe",
                    Arguments = $"-NoProfile -ExecutionPolicy Bypass -File \"{script}\"",
                    Verb = "runas", UseShellExecute = true, WindowStyle = ProcessWindowStyle.Hidden
                });
                await p!.WaitForExitAsync();
                await new ContentDialog { Title = "Done", Content = "Standby memory flushed.", CloseButtonText = "OK", XamlRoot = XamlRoot }.ShowAsync();
            }
            catch (Exception ex) { await new ContentDialog { Title = "Error", Content = ex.Message, CloseButtonText = "OK", XamlRoot = XamlRoot }.ShowAsync(); }
            finally { btnFlush.IsEnabled = true; }
        }

        private void BtnNetwork_Click(object sender, RoutedEventArgs e)
        {
            var cmd = Path.Combine(Environment.GetEnvironmentVariable("windir")!, "VoidDesktop", "9. Troubleshooting", "Network", "Reset Network to Void Default.cmd");
            if (File.Exists(cmd)) Process.Start(new ProcessStartInfo { FileName = cmd, Verb = "runas", UseShellExecute = true });
        }

        private async void BtnRestore_Click(object sender, RoutedEventArgs e)
        {
            btnRestore.IsEnabled = false;
            try
            {
                var p = Process.Start(new ProcessStartInfo
                {
                    FileName = "powershell.exe",
                    Arguments = "-NoProfile -Command \"Enable-ComputerRestore -Drive 'C:\\'; Checkpoint-Computer -Description 'Void OS Manual Restore Point' -RestorePointType MODIFY_SETTINGS\"",
                    Verb = "runas", UseShellExecute = true, WindowStyle = ProcessWindowStyle.Hidden
                });
                await p!.WaitForExitAsync();
                await new ContentDialog { Title = "Done", Content = "Restore point created.", CloseButtonText = "OK", XamlRoot = XamlRoot }.ShowAsync();
            }
            catch (Exception ex) { await new ContentDialog { Title = "Error", Content = ex.Message, CloseButtonText = "OK", XamlRoot = XamlRoot }.ShowAsync(); }
            finally { btnRestore.IsEnabled = true; }
        }

        private void BtnDesktop_Click(object sender, RoutedEventArgs e)
        {
            Process.Start("explorer.exe", Path.Combine(Environment.GetEnvironmentVariable("windir")!, "VoidDesktop"));
        }

        private void BtnLog_Click(object sender, RoutedEventArgs e)
        {
            var logDir = @"C:\VoidOS_Logs";
            if (!Directory.Exists(logDir)) { Process.Start("explorer.exe", logDir); return; }
            var logs = new DirectoryInfo(logDir).GetFiles("Optimization_*.log");
            if (logs.Length == 0) return;
            Array.Sort(logs, (a, b) => b.CreationTime.CompareTo(a.CreationTime));
            Process.Start(new ProcessStartInfo { FileName = logs[0].FullName, UseShellExecute = true });
        }

        private async void BtnPowerAuto_Click(object sender, RoutedEventArgs e) => await RunPowerModeAsync("Auto");
        private async void BtnPowerPerformance_Click(object sender, RoutedEventArgs e) => await RunPowerModeAsync("Performance");
        private async void BtnPowerBattery_Click(object sender, RoutedEventArgs e) => await RunPowerModeAsync("Battery");

        private async Task RunPowerModeAsync(string mode)
        {
            btnPowerAuto.IsEnabled = false;
            btnPowerPerformance.IsEnabled = false;
            btnPowerBattery.IsEnabled = false;

            try
            {
                var scriptPath = Path.Combine(Environment.GetEnvironmentVariable("windir")!, "VoidOS", "PowerProfiles", "VoidPowerMode.ps1");
                if (!File.Exists(scriptPath))
                {
                    await new ContentDialog { Title = "Missing Script", Content = $"Not found: {scriptPath}", CloseButtonText = "OK", XamlRoot = XamlRoot }.ShowAsync();
                    return;
                }

                await Task.Run(() =>
                {
                    using var runspace = RunspaceFactory.CreateRunspace();
                    runspace.Open();
                    using var ps = PowerShell.Create();
                    ps.Runspace = runspace;
                    ps.AddScript("& '" + scriptPath.Replace("'", "''") + "' -Mode " + mode);
                    var results = ps.Invoke();
                    if (ps.HadErrors)
                    {
                        var err = string.Join(Environment.NewLine, ps.Streams.Error.Select(e => e.ToString()));
                        throw new InvalidOperationException(err);
                    }
                });

                await new ContentDialog { Title = "Power Mode Applied", Content = $"Mode set to {mode}.", CloseButtonText = "OK", XamlRoot = XamlRoot }.ShowAsync();
            }
            catch (Exception ex)
            {
                await new ContentDialog { Title = "Error", Content = ex.Message, CloseButtonText = "OK", XamlRoot = XamlRoot }.ShowAsync();
            }
            finally
            {
                btnPowerAuto.IsEnabled = true;
                btnPowerPerformance.IsEnabled = true;
                btnPowerBattery.IsEnabled = true;
            }
        }
    }
}
