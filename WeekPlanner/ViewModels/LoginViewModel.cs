using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using WeekPlanner.Helpers;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Validations;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class LoginViewModel : ViewModelBase
    {
        private readonly IAccountApi _accountApi;
        private bool _isValid;
        private ValidatableObject<string> _password;
        private ValidatableObject<string> _userName;
        private bool _userModeSwitch = false;

        public LoginViewModel(IAccountApi accountApi, INavigationService navigationService) : base(navigationService)
        {
            _accountApi = accountApi;
            _userName = new ValidatableObject<string>(new IsNotNullOrEmptyRule<string>() { ValidationMessage = "Et brugernavn er påkrævet." });
            _password = new ValidatableObject<string>(new IsNotNullOrEmptyRule<string>() { ValidationMessage = "En adgangskode er påkrævet." });
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

        public bool IsValid
        {
            get => _isValid;
            set
            {
                _isValid = value;
                RaisePropertyChanged(() => IsValid);
            }
        }

        public ICommand LoginCommand => new Command(async () => { if (Validate()) await SendLoginRequest(); });

        public ICommand ValidateUserNameCommand => new Command(() => _userName.Validate());

        public ICommand ValidatePasswordCommand => new Command(() => _password.Validate());

        private async Task SendLoginRequest()
        {
            ResponseGirafUserDTO result;
            try
            {
                var loginDTO = new LoginDTO(UserName.Value, Password.Value);
                result = await _accountApi.V1AccountLoginPostAsync(loginDTO);
            }
            catch (ApiException)
            {
                // TODO make a "ServerDownError"
                var friendlyErrorMessage = ErrorCodeHelper.ToFriendlyString(ResponseGirafUserDTO.ErrorKeyEnum.Error);
                MessagingCenter.Send(this, MessageKeys.LoginFailed, friendlyErrorMessage);
                return;
            }

            if (result.Success == true)
            {
                MessagingCenter.Send(this, MessageKeys.LoginSucceeded, result.Data);
                result.Data.GuardianOf.OrderBy(x => x.Username);
                var dto = result.Data.GuardianOf;

                // Switch this to an actual token once implemented in backend
                GlobalSettings.Instance.AuthToken = result.Data.Id;

                if(_userModeSwitch)
                {
                    await NavigationService.PopAsync();
                }
                else
                {
                    await NavigationService.NavigateToAsync<ChooseCitizenViewModel>(dto);
                }
                
            }
            else
            {
                var friendlyErrorMessage = result.ErrorKey.ToFriendlyString();
                MessagingCenter.Send(this, MessageKeys.LoginFailed, friendlyErrorMessage);
            }
        }

        private bool Validate()
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
