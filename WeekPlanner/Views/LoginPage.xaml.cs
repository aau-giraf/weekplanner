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
        }

        private void OnLoginButtonClicked(object sender, EventArgs e)
        {
            string username = UsernameEntry.Text;
            string password = PasswordEntry.Text;
            
        }
    }
}
