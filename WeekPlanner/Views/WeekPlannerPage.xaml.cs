using System;
using WeekPlanner.ViewModels;
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

			MessagingCenter.Subscribe<WeekPlannerViewModel, string>(this, MessageKeys.RequestFailed,
				async (sender, message) => await DisplayAlert("Fejl", message, "Luk"));
			
			MessagingCenter.Subscribe<WeekPlannerViewModel, string>(this, MessageKeys.RequestSucceeded,
				async (sender, message) => await DisplayAlert("Success", message, "Luk"));
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
