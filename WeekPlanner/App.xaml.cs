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
using WeekPlanner.Views;
using System.Reflection;

namespace WeekPlanner
{
    public partial class App
    {
        public App()
        {
            InitializeComponent();

            //InitNavigation();
            FlowListView.Init();
            InitApplication();
            MainPage = new MasterPage();
        }

        private void InitApplication()
        {
            var appSettings = GetApplicationSettings();
            
            AppSetup setup = new AppSetup();
            AppContainer.Container = setup.CreateContainer(appSettings);
            
            //InitNavigation();
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
        }

        private static JsonObject GetApplicationSettings()
        {
            // Get current assembly. Needed because this is a shared project
            var assembly = IntrospectionExtensions.GetTypeInfo(typeof(App)).Assembly;

            Stream stream = assembly.GetManifestResourceStream("WeekPlanner.appsettings.Development.json");

            if(stream == null)
            {
                throw new FileLoadException("The file appsettings.Development.json could not be found. Read README.md for instructions.");
            }

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
