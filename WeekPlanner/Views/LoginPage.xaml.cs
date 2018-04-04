using System;
using IO.Swagger.Model;
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

            MessagingCenter.Subscribe<LoginViewModel, string>(this, MessageKeys.LoginFailed, async (sender, errorMessage) => {
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
