using System.Threading.Tasks;
using WeekPlanner.Views;
using Xamarin.Forms;
using WeekPlanner.ApplicationObjects;
using Autofac;
using WeekPlanner.Services.Navigation;

namespace WeekPlanner
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();

            AppSetup setup = new AppSetup();
            AppContainer.Container = setup.CreateContainer();
            
            InitNavigation();
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
