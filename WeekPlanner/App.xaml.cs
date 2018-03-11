using System;
using WeekPlanner.Views;
using Xamarin.Forms;
using WeekPlanner.Services.Networking;
using WeekPlanner.ApplicationObjects;
using Autofac;

namespace WeekPlanner
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();

            AppSetup setup = new AppSetup();
            AppContainer.Container = setup.CreateContainer();

            using(var scope = AppContainer.Container.BeginLifetimeScope())
            {
                MainPage = new NavigationPage(scope.Resolve<TestingPage>());
            }


        }
    }
}
