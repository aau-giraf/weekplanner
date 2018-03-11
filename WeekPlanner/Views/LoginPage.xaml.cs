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

        public LoginPage()
        {
            InitializeComponent();
            MessagingCenter.Subscribe<LoginViewModel, GirafUserDTO>(this, "LoginSuccess", async (sender, user) => {
                // TODO handle user
                var vm = new ChooseCitizenViewModel(null);
                vm.Username = user.Username;
                await Navigation.PushAsync(new ChooseCitizenPage(vm));
            });

            MessagingCenter.Subscribe<LoginViewModel, string>(this, "LoginFailed", async (sender, message) => {
                await DisplayAlert("Fejl", message, "Luk");
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

        void Handle_Completed(object sender, System.EventArgs e)
        {
            LoginButton.Command.Execute(null);
        }
    }
}
