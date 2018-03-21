using System;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace WeekPlanner.Views
{

    [XamlCompilation(XamlCompilationOptions.Compile)]
	public partial class WeekPlannerPage : ContentPage
	{
		public WeekPlannerPage()
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

        private async void Save_OnClicked(object sender, EventArgs e)
        {
            bool result = await DisplayAlert("Gem ugeplan", "Vil du gemme ugeplanen?", "Gem", "Annuller");
            if (result)
            {
                MessagingCenter.Send(this, MessageKeys.ScheduleSaveRequest);
            }
        }
    }
}
