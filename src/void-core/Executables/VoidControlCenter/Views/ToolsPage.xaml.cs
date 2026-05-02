using System;
using System.Diagnostics;
using System.IO;
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
    }
}
