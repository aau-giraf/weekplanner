using System.Threading.Tasks;
using Xamarin.Forms;

namespace WeekPlanner
{
    public class LoginViewModel : BaseViewModel
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public Command LoginCommand { get; set; }
        public IDataStore<Item> DataStore => DependencyService.Get<IDataStore<Item>>() ?? new MockDataStore();

        public LoginViewModel()
        {
            Title = "Login";
            LoginCommand = new Command(async () => await SendLoginRequest());
        }

        private async Task SendLoginRequest()
        {
            var result = await DataStore.SendLoginRequest(Username, Password);
        }
    }
}
