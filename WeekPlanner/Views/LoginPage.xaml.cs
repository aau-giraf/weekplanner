using System;
using System.Collections.Generic;
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
            MessagingCenter.Subscribe<LoginViewModel, string>(this, "MyAlertName", async (obj, message) => {
                if (message == "Godkendt")
                {
                    await Navigation.PushAsync(new NewItemPage());
                }
                await DisplayAlert("Log ind", message, "Luk");
            });
        }

    }
}
