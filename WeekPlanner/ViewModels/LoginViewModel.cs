using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
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
        
        private ValidatableObject<string> _password;
        private ValidatableObject<string> _userName;
        private bool _userModeSwitch = false;

        public LoginViewModel(INavigationService navigationService, 
            ILoginService loginService) : base(navigationService)
        {
            _loginService = loginService;
            _userName = new ValidatableObject<string>(new IsNotNullOrEmptyRule<string> { ValidationMessage = "Et brugernavn er påkrævet." });
            _password = new ValidatableObject<string>(new IsNotNullOrEmptyRule<string> { ValidationMessage = "En adgangskode er påkrævet." });
        }

        public ValidatableObject<string> UserName
        {
            get => _userName;
            set
            {
                _userName = value;
                RaisePropertyChanged(() => UserName);
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

        public ICommand LoginCommand => new Command(async () =>
        {
            if (UserNameAndPasswordIsValid())
            {
                if (_userModeSwitch)
                {
                    await NavigationService.PopAsync();
                }
                else
                {
                    await _loginService.LoginAndThenAsync(() => NavigationService.NavigateToAsync<ChooseCitizenViewModel>(),
                    UserType.Department, UserName.Value, Password.Value);
                }
            }
        });

        public ICommand ValidateUserNameCommand => new Command(() => _userName.Validate());

        public ICommand ValidatePasswordCommand => new Command(() => _password.Validate());

        public bool UserNameAndPasswordIsValid()
        {
            var isValidUser = _userName.Validate();
            var isValidPassword = _password.Validate();

            return isValidUser && isValidPassword;
        }

        public override async Task InitializeAsync(object navigationData)
        {
            if (navigationData is UserModeSwitchViewModel)
            {
                _userModeSwitch = true;
            } 
        }
    }
}
