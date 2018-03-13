using System.Threading.Tasks;
using IO.Swagger.Client;
using IO.Swagger.Model;
using Xamarin.Forms;
using WeekPlanner.Services.Networking;
using WeekPlanner.ViewModels.Base;
using WeekPlanner.Helpers;
using System.Windows.Input;
using System.Linq;


namespace WeekPlanner.ViewModels
{
    public class LoginViewModel : ViewModelBase
    {
        public string Username { get; set; }
        public string Password { get; set; }
        
        public ICommand LoginCommand => new Command(async () => await SendLoginRequest());

        private readonly INetworkingService _networkingService;

        public LoginViewModel(INetworkingService networkingService)
        {
            Title = "Log ind";
            _networkingService = networkingService;
        }

        private async Task SendLoginRequest()
        {
            ResponseGirafUserDTO result;
            try
            {
                result = await _networkingService.SendLoginRequest(Username, Password);
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

                await NavigationService.NavigateToAsync<ChooseCitizenViewModel>(dto);
            }
            else
            {
                var friendlyErrorMessage = result.ErrorKey.ToFriendlyString();
                MessagingCenter.Send(this, MessageKeys.LoginFailed, friendlyErrorMessage);
            }

        }
    }
}
