using System.Threading.Tasks;
using System.Windows.Input;
using WeekPlanner.Helpers;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Settings;
using WeekPlanner.Validations;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class LoginViewModel : ViewModelBase
    {
        private readonly ILoginService _loginService;
        private readonly ISettingsService _settingsService;

        private ValidatableObject<string> _username;
        private ValidatableObject<string> _password;
        
        private bool _userModeSwitch = false;
        

        public LoginViewModel(INavigationService navigationService,
            ILoginService loginService, ISettingsService settingsService) : base(navigationService)
        {
            _loginService = loginService;
            Password = new ValidatableObject<string>(new IsNotNullOrEmptyRule<string> { ValidationMessage = "En adgangskode er påkrævet." });
            Username = new ValidatableObject<string>(new IsNotNullOrEmptyRule<string> { ValidationMessage = "Et brugernavn er påkrævet." });

            ShowNavigationBar = false;     
			_settingsService = settingsService;
        }

        public ValidatableObject<string> Username
        {
            get => _username;
            set
            {
                _username = value;
                RaisePropertyChanged(() => Username);
            }
        }

        public ValidatableObject<string> Password
        {
            get => _password;
            set
            {
                _password = value;
                RaisePropertyChanged(() => Password);
            }
        }

        public ICommand LoginCommand => new Command(async () => await LoginIfUsernameAndPasswordAreValid());

        private async Task LoginIfUsernameAndPasswordAreValid()
        {
            if (IsBusy || !UserNameAndPasswordIsValid())
            {
                return;
            }

            if (_userModeSwitch)
            {
                IsBusy = true;
                bool enableGuardianMode = true;
                await _loginService.LoginAndThenAsync(UserType.Guardian, 
                    Username.Value, 
                    Password.Value, async () => {
                        await NavigationService.PopAsync(enableGuardianMode);
                        ClearUsernameAndPasswordFields();
                    });
                IsBusy = false;
            }
            else
            {
                IsBusy = true;
                await _loginService.LoginAndThenAsync(UserType.Guardian, 
                    Username.Value, 
                    Password.Value, 
                    async () => {
                        await NavigationService.NavigateToAsync<ChooseCitizenViewModel>();
                        ClearUsernameAndPasswordFields();
                    });
                IsBusy = false;
            }
        }

        public ICommand ValidateUsernameCommand => new Command(() => Username.Validate());
        public ICommand ValidatePasswordCommand => new Command(() => Password.Validate());

        private void ClearUsernameAndPasswordFields()
        {
            Username.Value = "";
            Password.Value = "";
        }

        public bool UserNameAndPasswordIsValid()
        {
            var usernameIsValid = Username.Validate();
            var passwordIsValid = Password.Validate();
            return usernameIsValid && passwordIsValid;
        }

        public override Task InitializeAsync(object navigationData)
        {
            if (navigationData is WeekPlannerViewModel)
            {
                _userModeSwitch = true;
                ShowNavigationBar = true;
				return Task.FromResult(true);
            }

			// This is a logout, so clear settings
            _settingsService.ClearSettings();

            return Task.FromResult(false);
        }
    }
}
