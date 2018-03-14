using Autofac;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Views;
using WeekPlanner.ViewModels;
using IO.Swagger.Api;
using WeekPlanner.Services.Mocks;
using IO.Swagger.Client;
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

            // Services
            cb.RegisterType<NavigationService>().As<INavigationService>();

            // *** Conditional Registrations ***
            if (GlobalSettings.Instance.UseMocks)
            {
                cb.RegisterType<AccountMockService>().As<IAccountApi>();
            }
            else
            {
                var accountApi = new AccountApi();
                accountApi.Configuration.ApiClient = new ApiClient(GlobalSettings.DefaultEndpoint);

                cb.RegisterType<AccountApi>().As<IAccountApi>();
            }
        }
    }
}
