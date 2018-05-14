using Autofac;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels;
using IO.Swagger.Api;
using SimpleJson;
using WeekPlanner.Services.Settings;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Request;
using WeekPlanner.Services;

namespace WeekPlanner.ApplicationObjects
{
    public sealed class AppSetup
    {
        private JsonObject _appSettings;
        
        public IContainer CreateContainer(JsonObject appSettings)
        {
            _appSettings = appSettings;
            var containerBuilder = new ContainerBuilder();
            RegisterDependencies(containerBuilder);
            return containerBuilder.Build();
        }

        private void RegisterDependencies(ContainerBuilder cb)
        {
            // *** Constant Registrations ***
            // ViewModels
            cb.RegisterType<ChooseCitizenViewModel>();
            cb.RegisterType<LoginViewModel>();
            cb.RegisterType<TestingViewModel>();
            cb.RegisterType<WeekPlannerViewModel>();
            cb.RegisterType<ChooseTemplateViewModel>();
            cb.RegisterType<PictogramSearchViewModel>();
			cb.RegisterType<SettingsViewModel>();
            cb.RegisterType<MasterViewModel>();
            cb.RegisterType<CitizenSchedulesViewModel>();
            cb.RegisterType<NewScheduleViewModel>();
            cb.RegisterType<ActivityViewModel>();
            cb.RegisterType<ChoiceBoardViewModel>();
            cb.RegisterType<WeekPlannerTemplateViewModel>();

            // Services
			cb.RegisterType<NavigationService>().As<INavigationService>();
            cb.RegisterType<DialogService>().As<IDialogService>();
            cb.RegisterType<RequestService>().As<IRequestService>();
            cb.RegisterType<SettingsService>().As<ISettingsService>()
                .SingleInstance()
                .WithParameter("appSettings", _appSettings);
        
            var accountApi = new AccountApi {Configuration = {BasePath = _appSettings["BaseEndpoint"].ToString()}};
            cb.RegisterInstance<IAccountApi>(accountApi);
            cb.RegisterType<LoginService>().As<ILoginService>();
            cb.RegisterType<WeekApi>().As<IWeekApi>();
            cb.RegisterType<PictogramApi>().As<IPictogramApi>();
            cb.RegisterType<DepartmentApi>().As<IDepartmentApi>();
            cb.RegisterType<PictogramApi>().As<IPictogramApi>();
			cb.RegisterType<UserApi>().As<IUserApi>();
            cb.RegisterType<WeekTemplateApi>().As<IWeekTemplateApi>();
        }
    }
}
