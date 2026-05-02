using Microsoft.UI;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;
using VoidControlCenter.Services;

namespace VoidControlCenter.Views
{
    public sealed partial class OverviewPage : Page
    {
        public OverviewPage()
        {
            this.InitializeComponent();
            this.Loaded += OnLoaded;
        }

        private void OnLoaded(object sender, RoutedEventArgs e)
        {
            var hw = HardwareInfo.Detect();
            txtCpu.Text     = hw.CpuName;
            txtArch.Text    = hw.CpuArch;
            txtRam.Text     = hw.RamAmount;
            txtGpu.Text     = hw.GpuName;
            txtChassis.Text = hw.Chassis;

            var eng = EngineStatus.Check();
            txtLastRun.Text = $"Engine last executed: {eng.LastLogDate}";

            ApplyStatus(dotIRQ,    lblIRQ,    eng.IRQAffinity);
            ApplyStatus(dotNDIS,   lblNDIS,   eng.NDISOptimizer);
            ApplyStatus(dotASPM,   lblASPM,   eng.PCIeASPM);
            ApplyStatus(dotPaging, lblPaging,  eng.DynamicPaging);
            ApplyStatus(dotStandby,lblStandby, eng.StandbyCleaner);
            ApplyStatus(dotPerf,   lblPerf,    eng.ExtremePerformance);
        }

        private static void ApplyStatus(Microsoft.UI.Xaml.Shapes.Ellipse dot,
                                        TextBlock label, bool applied)
        {
            dot.Fill  = new SolidColorBrush(applied
                ? Color.FromArgb(255, 0, 217, 126)
                : Color.FromArgb(255, 255, 58, 58));
            label.Text = applied ? "Applied" : "Not Applied";
        }
    }
}
