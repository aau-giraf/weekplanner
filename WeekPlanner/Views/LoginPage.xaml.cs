using WeekPlanner.Services.Login;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.Views
{
    public partial class LoginPage : ContentPage
    {
        public LoginPage()
        {
            InitializeComponent();

            MessagingCenter.Subscribe<LoginService, string>(this, MessageKeys.RequestFailed, async (sender, errorMessage) => {
                await DisplayAlert("Fejl", errorMessage, "Luk");
            });
        }

        void Username_Completed(object sender, System.EventArgs e)
        {
            PasswordEntry.Focus();
        }

        void Password_Completed(object sender, System.EventArgs e)
        {
            LoginButton.Command.Execute(null);
        }
    }
}
