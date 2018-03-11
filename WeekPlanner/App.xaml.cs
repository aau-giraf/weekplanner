using System;
using WeekPlanner.Views;
using Xamarin.Forms;
using WeekPlanner.Services.Networking;

namespace WeekPlanner
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();

            if (GlobalSettings.Instance.UseMocks)
                DependencyService.Register<MockNetworkingService>();
            else
                DependencyService.Register<NetworkingService>();

            if (Device.RuntimePlatform == Device.iOS)
                MainPage = new NavigationPage(new TestingPage());
            else
                MainPage = new NavigationPage(new TestingPage());
        }
    }
}
