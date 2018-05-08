using WeekPlanner.Views.Base;
using Xamarin.Forms;

namespace WeekPlanner.Views
{
    public partial class LoginPage : PageBase
    {       
        public LoginPage()
        {
            InitializeComponent();
            if (Device.Idiom == TargetIdiom.Phone)
            {
                StackTitle.Margin = new Thickness(0, 20, 0, 30);
                LoginButton.Margin = new Thickness(80, 5, 80, 0);
            }
        }

        private void Username_Completed(object sender, System.EventArgs e)
        {
            PasswordEntry.Focus();
        }

        private void Password_Completed(object sender, System.EventArgs e)
        {
            LoginButton.Command.Execute(null);
        }
    }
}
