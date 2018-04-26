using System;
using System.Collections.Generic;

using Xamarin.Forms;

namespace WeekPlanner.Views
{
    public partial class SettingsPage : ContentPage
    {
        public SettingsPage()
        {
            InitializeComponent();
        }

		public void Picker_SelectedIndexChanged(object sender, EventArgs e)
		{
			DisplayAlert("Hey", "{Aids}", "cool");
		}

	}
}
