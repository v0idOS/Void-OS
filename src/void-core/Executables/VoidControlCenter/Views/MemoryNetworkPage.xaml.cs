using System;
using System.Diagnostics;
using System.IO;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.Win32;

namespace VoidControlCenter.Views
{
    public sealed partial class MemoryNetworkPage : Page
    {
        public MemoryNetworkPage()
        {
            this.InitializeComponent();
            this.Loaded += (s, e) => LoadStatus();
        }

        private void LoadStatus()
        {
            try
            {
                var key = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management");
                var init = key?.GetValue("PagingFiles");
                txtPageFile.Text = init != null ? "8192 MB Static" : "Managed";
            }
            catch { txtPageFile.Text = "Unknown"; }
        }

        private async void BtnFlush_Click(object sender, RoutedEventArgs e)
        {
            btnFlush.IsEnabled = false;
            try
            {
                var ps = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = "powershell.exe",
                        Arguments = $"-NoProfile -ExecutionPolicy Bypass -File \"{Path.Combine(Environment.GetEnvironmentVariable("windir")!, "VoidDesktop", "StandbyCleaner.ps1")}\"",
                        Verb = "runas", UseShellExecute = true, WindowStyle = ProcessWindowStyle.Hidden
                    }
                };
                ps.Start();
                await ps.WaitForExitAsync();

                var dialog = new ContentDialog { Title = "Done", Content = "Standby memory flushed.", CloseButtonText = "OK", XamlRoot = this.XamlRoot };
                await dialog.ShowAsync();
            }
            catch (Exception ex)
            {
                var dialog = new ContentDialog { Title = "Error", Content = ex.Message, CloseButtonText = "OK", XamlRoot = this.XamlRoot };
                await dialog.ShowAsync();
            }
            finally { btnFlush.IsEnabled = true; }
        }

        private void BtnNetwork_Click(object sender, RoutedEventArgs e)
        {
            var cmd = Path.Combine(Environment.GetEnvironmentVariable("windir")!, "VoidDesktop", "9. Troubleshooting", "Network", "Reset Network to Void Default.cmd");
            if (File.Exists(cmd))
                Process.Start(new ProcessStartInfo { FileName = cmd, Verb = "runas", UseShellExecute = true });
        }
    }
}
