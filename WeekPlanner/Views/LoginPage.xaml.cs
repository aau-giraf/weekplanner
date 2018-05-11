using WeekPlanner.ViewModels;
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
            
            #if DEBUG
            EntriesAndButtonsStackLayout.Children.Add(new Button
            {
                Text = "Autofill and Login",
                Margin= new Thickness(80, 20, 80, 0),
                WidthRequest= 200,
                Command = new Command(() =>
                {
                    UsernameEntry.Text = "Graatand";
                    PasswordEntry.Text = "password";
                    (BindingContext as LoginViewModel)?.LoginCommand.Execute(null);
                })
            });
            #endif
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
