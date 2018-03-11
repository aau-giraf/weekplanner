using System;
using System.Collections.Generic;
using IO.Swagger.Model;
using Newtonsoft.Json;
using Newtonsoft.Json.Schema;
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
                await Navigation.PushAsync(new MainPage());
            });

            MessagingCenter.Subscribe<LoginViewModel, string>(this, "LoginFailed", async (sender, message) => {
                await DisplayAlert("Fejl", message, "Luk");
            });
        }

        private void MenuItem_OnClicked(object sender, EventArgs e)
        {
            DisplayAlert("Indstillinger", "Du trykkede på indstillinger!", "Luk");
        }
    }
}
