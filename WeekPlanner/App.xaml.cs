using System;
using WeekPlanner.Views;
using Xamarin.Forms;

namespace WeekPlanner
{
    public partial class App : Application
    {
        public static bool UseMockDataStore = true;
        public static string BackendUrl = "http://localhost:5000/v1";

        public App()
        {
            InitializeComponent();

            if (UseMockDataStore)
                DependencyService.Register<MockDataStore>();
            else
                DependencyService.Register<CloudDataStore>();

            if (Device.RuntimePlatform == Device.iOS)
                MainPage = new LoginPage();
            else
                MainPage = new NavigationPage(new LoginPage());
        }
    }
}
