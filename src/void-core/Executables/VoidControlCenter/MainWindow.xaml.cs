using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Windowing;
using Microsoft.UI;
using VoidControlCenter.Views;

namespace VoidControlCenter
{
    public sealed partial class MainWindow : Window
    {
        public MainWindow()
        {
            this.InitializeComponent();

            // Set window size and title bar
            var appWindow = this.AppWindow;
            appWindow.Resize(new Windows.Graphics.SizeInt32(1100, 720));
            appWindow.Title = "Void Control Center";

            // Custom title bar
            if (AppWindowTitleBar.IsCustomizationSupported())
            {
                var titleBar = appWindow.TitleBar;
                titleBar.ExtendsContentIntoTitleBar = true;
                titleBar.ButtonBackgroundColor = Colors.Transparent;
                titleBar.ButtonInactiveBackgroundColor = Colors.Transparent;
                titleBar.PreferredHeightOption = TitleBarHeightOption.Tall;
            }

            // Set ExtendsContentIntoTitleBar
            ExtendsContentIntoTitleBar = true;
            SetTitleBar(AppTitleBar);

            // Navigate to overview on start
            NavView.SelectedItem = NavView.MenuItems[0];
            ContentFrame.Navigate(typeof(OverviewPage));
        }

        private void NavView_SelectionChanged(NavigationView sender, NavigationViewSelectionChangedEventArgs args)
        {
            if (args.SelectedItem is NavigationViewItem item)
            {
                ContentFrame.Navigate(item.Tag?.ToString() switch
                {
                    "overview"    => typeof(OverviewPage),
                    "performance" => typeof(PerformancePage),
                    "memory"      => typeof(MemoryNetworkPage),
                    "tools"       => typeof(ToolsPage),
                    _             => typeof(OverviewPage)
                });
            }
        }
    }
}
