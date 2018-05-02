using Autofac;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels;
using IO.Swagger.Api;
using SimpleJson;
using WeekPlanner.Services.Mocks;
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
            cb.RegisterType<SavePromptViewModel>();
            cb.RegisterType<CitizenSchedulesViewModel>();
            cb.RegisterType<NewScheduleViewModel>();

            // Services
			cb.RegisterType<NavigationService>().As<INavigationService>();
            cb.RegisterType<DialogService>().As<IDialogService>();
            cb.RegisterType<RequestService>().As<IRequestService>();
            cb.RegisterType<SettingsService>().As<ISettingsService>()
                .SingleInstance()
                .WithParameter("appSettings", _appSettings);

            // *** Conditional Registrations ***
            if (_appSettings["UseMocks"].ToString() == "true")
            {
                cb.RegisterType<MockAccountApi>().As<IAccountApi>();
                cb.RegisterType<MockDepartmentApi>().As<IDepartmentApi>();
                cb.RegisterType<MockWeekApi>().As<IWeekApi>();
                cb.RegisterType<MockPictogramApi>().As<IPictogramApi>();
                cb.RegisterType<MockLoginService>().As<ILoginService>();
            }
            else
            {
                var accountApi = new AccountApi {Configuration = {BasePath = _appSettings["BaseEndpoint"].ToString()}};
                cb.RegisterInstance<IAccountApi>(accountApi);
                cb.RegisterType<LoginService>().As<ILoginService>();
                cb.RegisterType<WeekApi>().As<IWeekApi>();
                cb.RegisterType<PictogramApi>().As<IPictogramApi>();
                cb.RegisterType<DepartmentApi>().As<IDepartmentApi>();
                cb.RegisterType<PictogramApi>().As<IPictogramApi>();
				cb.RegisterType<UserApi>().As<IUserApi>();
			}
        }
    }
}
