using System.Threading.Tasks;
using Autofac;
using WeekPlanner.ApplicationObjects;
using WeekPlanner.Services.Navigation;

namespace WeekPlanner.ViewModels.Base
{
    public abstract class ViewModelBase : ExtendedBindableObject
    {
        protected readonly INavigationService NavigationService;

        private bool _isBusy;

        public bool IsBusy
        {
            get => _isBusy;

            set
            {
                _isBusy = value;
                RaisePropertyChanged(() => IsBusy);
            }
        }

        protected ViewModelBase()
        {
            using (var scope = AppContainer.Container.BeginLifetimeScope())
            {
                NavigationService = scope.Resolve<INavigationService>();
            }
            
        }

        public virtual Task InitializeAsync(object navigationData)
        {
            return Task.FromResult(false);
        }
    }
}
