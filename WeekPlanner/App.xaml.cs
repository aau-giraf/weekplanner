using System.Net.Http;
using System.Threading.Tasks;
using Xamarin.Forms;
using WeekPlanner.ApplicationObjects;
using Autofac;
using WeekPlanner.Services.Navigation;
using DLToolkit.Forms.Controls;
using FFImageLoading.Config;
using WeekPlanner.Services.Settings;
using WeekPlanner.Views;

namespace WeekPlanner
{
    public partial class App : Application
    {
        public App()
        {
            
            FFImageLoading.ImageService.Instance.Initialize(new Configuration()
            {
                HttpClient =
                    new HttpClient(
                        new GirafAuthenticatedHttpImageClientHelper(SettingsService.GetToken))
            });
            
            InitializeComponent();

            AppSetup setup = new AppSetup();
            AppContainer.Container = setup.CreateContainer();
            MainPage = new MasterPage();
            //InitNavigation();
            FlowListView.Init(); 
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
