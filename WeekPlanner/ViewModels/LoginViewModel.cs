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
            _networkingService = networkingService;
        }

        private async Task SendLoginRequest()
        {
            ResponseGirafUserDTO result = new ResponseGirafUserDTO();
            try
            {
                result = await _networkingService.SendLoginRequest(Username, Password);
            }
            catch (ApiException)
            {
                // TODO make a "ServerDownError"
                var friendlyErrorMessage = ErrorCodeHelper.ToFriendlyString(ResponseGirafUserDTO.ErrorKeyEnum.Error);
                MessagingCenter.Send(this, "LoginFailed", friendlyErrorMessage);
                return;
            }
            if (result.Success == null)
                result.Success = false;

            if ((bool)result.Success)
            {
                MessagingCenter.Send(this, "LoginSuccess", result.Data);
                result.Data.GuardianOf.OrderBy(x => x.Username);
                var dto = result.Data.GuardianOf;
                await NavigationService.NavigateToAsync<ChooseCitizenViewModel>(dto);
            }
            else
            {
                var friendlyErrorMessage = result.ErrorKey.ToFriendlyString();
                MessagingCenter.Send(this, "LoginFailed", friendlyErrorMessage);
            }

        }
    }
}
