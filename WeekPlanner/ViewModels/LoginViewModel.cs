using System;
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

        private ValidatableObject<string> _username;
        private ValidatableObject<string> _password;

        private bool _userModeSwitch = false;

        public LoginViewModel(INavigationService navigationService,
            ILoginService loginService) : base(navigationService)
        {
            _loginService = loginService;
            Password = new ValidatableObject<string>(new IsNotNullOrEmptyRule<string> { ValidationMessage = "En adgangskode er påkrævet." });
            Username = new ValidatableObject<string>(new IsNotNullOrEmptyRule<string> { ValidationMessage = "Et brugernavn er påkrævet." });
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

        public ICommand LoginCommand => new MutexCommand(async () => await LoginIfUsernameAndPasswordAreValid());

        private async Task LoginIfUsernameAndPasswordAreValid()
        {
            if (!UserNameAndPasswordIsValid())
            {
                return;
            }
            if (_userModeSwitch)
            {
                bool enableGuardianMode = true;
                await _loginService.LoginAndThenAsync(
                    () => NavigationService.PopAsync(enableGuardianMode),
                    UserType.Guardian, 
                    Username.Value, 
                    Password.Value
                );
            }
            else
            {
                await _loginService.LoginAndThenAsync(
                    () => NavigationService.NavigateToAsync<ChooseCitizenViewModel>(),
                    UserType.Guardian, 
                    Username.Value, 
                    Password.Value
                );
            }
        }

        public ICommand ValidateUsernameCommand => new Command(() => Username.Validate());
        public ICommand ValidatePasswordCommand => new Command(() => Password.Validate());

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
            }
            return Task.FromResult(false);
        }
    }
}
