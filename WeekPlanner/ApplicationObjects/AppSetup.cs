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
            cb.RegisterType<ChooseDepartmentViewModel>();

            // Services
            cb.RegisterType<NavigationService>().As<INavigationService>();
            cb.RegisterType<SettingsService>().As<ISettingsService>();

            // *** Conditional Registrations ***
            if (GlobalSettings.Instance.UseMocks)
            {
                cb.RegisterType<AccountMockService>().As<IAccountApi>();
                cb.RegisterType<DepartmentMockService>().As<IDepartmentApi>();
            }
            else
            {
                var accountApi = new AccountApi(GlobalSettings.DefaultEndpoint);
                cb.RegisterInstance<IAccountApi>(accountApi);

                var departmentApi = new DepartmentApi(GlobalSettings.DefaultEndpoint);
                cb.RegisterInstance<IDepartmentApi>(departmentApi);
            }
        }
    }
}
