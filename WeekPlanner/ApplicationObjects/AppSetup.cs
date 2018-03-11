using System;
using Autofac;
using WeekPlanner.Services.Networking;
using WeekPlanner.Views;
using WeekPlanner.ViewModels;

namespace WeekPlanner
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
            // Constant Registrations
            // ViewModel
            cb.RegisterType<ChooseCitizenViewModel>();
            cb.RegisterType<LoginViewModel>();

            // Views
            cb.RegisterType<LoginPage>();
            cb.RegisterType<TestingPage>();
            cb.RegisterType<ChooseCitizenPage>();

           // Conditional Registrations
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
