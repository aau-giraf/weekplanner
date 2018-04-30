using Autofac;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels;
using IO.Swagger.Api;
using WeekPlanner.Services.Mocks;
using WeekPlanner.Services.Settings;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Request;
using WeekPlanner.Services;

namespace WeekPlanner.ApplicationObjects
{
    public class AppSetup
    {
        public IContainer CreateContainer()
        {
            var containerBuilder = new ContainerBuilder();
            RegisterDependencies(containerBuilder);
            return containerBuilder.Build();
        }

        protected virtual void RegisterDependencies(ContainerBuilder cb)
        {
            // *** Constant Registrations ***
            // ViewModels
            cb.RegisterType<ChooseCitizenViewModel>();
            cb.RegisterType<LoginViewModel>();
            cb.RegisterType<TestingViewModel>();
            cb.RegisterType<WeekPlannerViewModel>();
            cb.RegisterType<ChooseTemplateViewModel>();
            cb.RegisterType<PictogramSearchViewModel>();
            cb.RegisterType<ActivityViewModel>();
            cb.RegisterType<MasterViewModel>();

            // Services
            cb.RegisterType<NavigationService>().As<INavigationService>();
            cb.RegisterType<SettingsService>().As<ISettingsService>();
            cb.RegisterType<DialogService>().As<IDialogService>();
            cb.RegisterType<RequestService>().As<IRequestService>();

            // *** Conditional Registrations ***
            if (GlobalSettings.Instance.UseMocks)
            {
                cb.RegisterType<MockAccountApi>().As<IAccountApi>();
                cb.RegisterType<MockDepartmentApi>().As<IDepartmentApi>();
                cb.RegisterType<MockWeekApi>().As<IWeekApi>();
                cb.RegisterType<MockPictogramApi>().As<IPictogramApi>();
                cb.RegisterType<MockLoginService>().As<ILoginService>();
            }
            else
            {
                var accountApi = new AccountApi {Configuration = {BasePath = GlobalSettings.Instance.BaseEndpoint}};
                cb.RegisterInstance<IAccountApi>(accountApi);
                cb.RegisterType<LoginService>().As<ILoginService>();
                cb.RegisterType<WeekApi>().As<IWeekApi>();
                cb.RegisterType<PictogramApi>().As<IPictogramApi>();
                cb.RegisterType<DepartmentApi>().As<IDepartmentApi>();
                cb.RegisterType<PictogramApi>().As<IPictogramApi>();
            }
        }
    }
}
