using System;
using System.Collections.Generic;
using IO.Swagger.Model;
using Newtonsoft.Json;
using Newtonsoft.Json.Schema;
using WeekPlanner.ViewModels;
using Xamarin.Forms;

namespace WeekPlanner.Views
{
    public partial class LoginPage : ContentPage
    {
        public LoginPage(LoginViewModel loginViewModel)
        {
            InitializeComponent();

            BindingContext = loginViewModel;

            MessagingCenter.Subscribe<LoginViewModel, GirafUserDTO>(this, "LoginSuccess", async (sender, user) => {
                var vm = new ChooseCitizenViewModel(user.GuardianOf)
                {
                    Username = user.Username
                };
                // TODO save all the user information
                await Navigation.PushAsync(new ChooseCitizenPage(vm));
            });

            MessagingCenter.Subscribe<LoginViewModel, string>(this, "LoginFailed", async (sender, errorMessage) => {
                await DisplayAlert("Fejl", errorMessage, "Luk");
            });

        }

        private void MenuItem_OnClicked(object sender, EventArgs e)
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
