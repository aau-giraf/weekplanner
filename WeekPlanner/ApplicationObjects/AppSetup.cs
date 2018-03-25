using Autofac;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Views;
using WeekPlanner.ViewModels;
using IO.Swagger.Api;
using WeekPlanner.Services.Mocks;
using IO.Swagger.Client;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;

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

            // Services
            cb.RegisterType<NavigationService>().As<INavigationService>();
            cb.RegisterType<SettingsService>().As<ISettingsService>();

            // *** Conditional Registrations ***
            if (GlobalSettings.Instance.UseMocks)
            {
                cb.RegisterType<AccountMockService>().As<IAccountApi>();
                cb.RegisterType<DepartmentApiMock>().As<IDepartmentApi>();
            }
            else
            {
                var accountApi = new AccountApi();
                accountApi.Configuration.BasePath = GlobalSettings.Instance.BaseEndpoint;
                // TODO: Use AuthToken currently in use from GlobalSettings
                cb.RegisterInstance<IAccountApi>(accountApi);
                
                cb.RegisterType<DepartmentApi>().As<IDepartmentApi>();
            }
        }
    }
}
