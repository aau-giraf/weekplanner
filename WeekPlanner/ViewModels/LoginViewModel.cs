using System.Threading.Tasks;
using IO.Swagger.Model;
using Xamarin.Forms;

namespace WeekPlanner
{
    public class LoginViewModel : BaseViewModel
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public Command LoginCommand { get; set; }

        public LoginViewModel()
        {
            Title = "Log ind";
            LoginCommand = new Command(async () => await SendLoginRequest());
        }

        private async Task SendLoginRequest()
        {
            var result = await DataStore.SendLoginRequest(Username, Password);

            if (result.Success == null)
                result.Success = false;

            if ((bool)result.Success)
            {
                MessagingCenter.Send(this, "LoginSuccess", result.Data);
            }
            else
            {
                var friendlyErrorMessage = result.ErrorKey.ToFriendlyString();
                MessagingCenter.Send(this, "LoginFailed", friendlyErrorMessage);
            }

        }
    }
}
