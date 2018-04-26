using System.IO;
using System.Net.Http;
using WeekPlanner.ApplicationObjects;
using Autofac;
using WeekPlanner.Services.Navigation;
using DLToolkit.Forms.Controls;
using FFImageLoading.Config;
using Newtonsoft.Json;
using SimpleJson;
using WeekPlanner.Services.Settings;
using System.Reflection;

namespace WeekPlanner
{
    public partial class App
    {
        public App()
        {
            InitializeComponent();
            InitApplication();
        }

        private void InitApplication()
        {
            var appSettings = GetApplicationSettings();
            
            AppSetup setup = new AppSetup();
            AppContainer.Container = setup.CreateContainer(appSettings);
            
            InitNavigation();
            InitFFImage();
        }

        private void InitFFImage()
        {
            FFImageLoading.ImageService.Instance.Initialize(new Configuration
            {
                HttpClient =
                    new HttpClient(
                        new GirafAuthenticatedHttpImageClientHelper(SettingsService.GetToken))
            });
            
            FlowListView.Init(); 
        }

        private static JsonObject GetApplicationSettings()
        {
            // Get current assembly. Needed because this is a shared project
            var assembly = IntrospectionExtensions.GetTypeInfo(typeof(App)).Assembly;

            Stream stream = assembly.GetManifestResourceStream("WeekPlanner.appsettings.json");

            using (var reader = new StreamReader(stream))
            {
                JsonSerializer serializer = new JsonSerializer();
                return (JsonObject)serializer.Deserialize(reader, typeof(JsonObject));
            }
        }
        
        private static void InitNavigation()
        {
            using (var scope = AppContainer.Container.BeginLifetimeScope())
            {
                var navigationService = scope.Resolve<INavigationService>();
                navigationService.InitializeAsync();
            }
        }
    }
}
