using System.Threading.Tasks;
using System.Windows.Input;
using WeekPlanner.Services.Navigation;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels.Base
{
    public abstract class ViewModelBase : ExtendedBindableObject
    {
        protected readonly INavigationService NavigationService;

        private bool _showBackButton = true;
        public bool ShowBackButton
        {
            get => _showBackButton;
            set
            {
                _showBackButton = value;
                RaisePropertyChanged(() => ShowBackButton);
            }
        }

        private bool _showNavigationBar = true;

        public bool ShowNavigationBar
        {
            get => _showNavigationBar;
            set
            {
                _showNavigationBar = value;
                RaisePropertyChanged(() => ShowNavigationBar);
            }
        }
        
        private ICommand _onBackButtonPressedCommand;

        public ICommand OnBackButtonPressedCommand
        {
            get => _onBackButtonPressedCommand;
            set
            {
                _onBackButtonPressedCommand = value;
                RaisePropertyChanged(() => OnBackButtonPressedCommand);
            }
        }


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

        public ViewModelBase(INavigationService navigationService)
        {
            NavigationService = navigationService;
            OnBackButtonPressedCommand = new Command(async () =>
            {
                if (IsBusy) return;
                IsBusy = true;
                await NavigationService.PopAsync();
                IsBusy = false;
            });
        }

        public virtual Task InitializeAsync(object navigationData)
        {
            return Task.FromResult(false);
        }

        public virtual Task PoppedAsync(object navigationData) {
            return Task.FromResult(false);
         }
    }
}
