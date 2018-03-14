using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace WeekPlanner.Views
{
	[XamlCompilation(XamlCompilationOptions.Compile)]
	public partial class UserModeSwitchPage : ContentPage
	{
		public UserModeSwitchPage ()
		{
			InitializeComponent();
		}

		private void Settings_OnClicked(object sender, EventArgs e)
		{
			DisplayAlert("Indstillinger", "Du trykkede på indstillinger!", "Luk");
		}

		private void Edit_OnClicked(object sender, EventArgs e)
		{
		}

		private void ChangeCitizen_OnClicked(object sender, EventArgs e)
		{
		}
	}
}