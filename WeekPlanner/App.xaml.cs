using System;
using WeekPlanner.Views;
using Xamarin.Forms;

namespace WeekPlanner
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();

            if (GlobalSettings.Instance.UseMocks)
                DependencyService.Register<MockDataStore>();
            else
                DependencyService.Register<CloudDataStore>();

            if (Device.RuntimePlatform == Device.iOS)
                MainPage = new NavigationPage(new TestingPage());
            else
                MainPage = new NavigationPage(new TestingPage());
        }
    }
}
