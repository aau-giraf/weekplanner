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

        public LoginViewModel(INavigationService navigationService, 
            ILoginService loginService) : base(navigationService)
        {
            _loginService = loginService;
            _password = new ValidatableObject<string>(new IsNotNullOrEmptyRule<string> { ValidationMessage = "En adgangskode er påkrævet." });
        }

        public string DepartmentName => GlobalSettings.Instance.Department.Name;

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
                await _loginService.LoginAndThenAsync(() => NavigationService.NavigateToAsync<ChooseCitizenViewModel>(), 
                    UserType.Department, UserName.Value, Password.Value);
            }
        });

        public ICommand ValidatePasswordCommand => new Command(() => _password.Validate());

        public bool UserNameAndPasswordIsValid()
        {
            var isValidPassword = _password.Validate();
            return isValidPassword;
        }
    }
}
