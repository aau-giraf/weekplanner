using System;
using System.Threading.Tasks;
using WeekPlanner.Views;
using Xamarin.Forms;
using WeekPlanner.Services.Networking;
using WeekPlanner.ApplicationObjects;
using Autofac;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();

            AppSetup setup = new AppSetup();
            AppContainer.Container = setup.CreateContainer();

            using (var scope = AppContainer.Container.BeginLifetimeScope())
            {
                MainPage = new CustomNavigationPage(scope.Resolve<TestingPage>());
                var navigationService = scope.Resolve<INavigationService>();
                navigationService.InitializeAsync();
            }
        }
        
        private Task InitNavigation()
        {
            using (var scope = AppContainer.Container.BeginLifetimeScope())
            {
                var navigationService = scope.Resolve<INavigationService>();
                return navigationService.InitializeAsync();
            }
        }
    }
}
