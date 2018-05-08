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
            NavigationPage.SetHasNavigationBar(this, false);
            if (Device.Idiom == TargetIdiom.Phone)
            {
                StackTitle.Margin = new Thickness(0, 20, 0, 30);
                LoginButton.Margin = new Thickness(80, 5, 80, 0);
            }
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
