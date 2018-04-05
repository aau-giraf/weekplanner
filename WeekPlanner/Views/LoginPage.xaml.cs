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

        private void Settings_OnClicked(object sender, EventArgs e)
        {
            DisplayAlert("Indstillinger", "Du trykkede på indstillinger!", "Luk");
        }

        void Username_Completed(object sender, System.EventArgs e)
        {
            PasswordEntry.Focus();
        }

        void Password_Completed(object sender, System.EventArgs e)
        {
            LoginButton.Command.Execute(null);
        }

        private void Autofill_Clicked(object sender, EventArgs e)
        {
            UsernameEntry.Text = "Graatand";
            PasswordEntry.Text = "password";
            LoginButton.Command.Execute(null);
        }
    }
}
