using System;
using Autofac;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Networking;
using WeekPlanner.Views;
using WeekPlanner.ViewModels;

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

            // Views
            cb.RegisterType<TestingView>();
            cb.RegisterType<LoginView>();
            cb.RegisterType<ChooseCitizenView>();

            // Services
            cb.RegisterType<NavigationService>().As<INavigationService>();

            // *** Conditional Registrations ***
            if(GlobalSettings.Instance.UseMocks)
            {
                cb.RegisterType<MockNetworkingService>().As<INetworkingService>();
            }
            else 
            {
                cb.RegisterType<NetworkingService>().As<INetworkingService>();
            }
        }
    }
}
