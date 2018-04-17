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

		//TODO: 
		/*
		* The following allows for specification of the orientation of the WeekPlannerPage. 
		* This, however, is dependent on the not yet implemented user story regarding citizen orientation setting
		* and should be set accordingly once this has been implemented. 
		*/
		//protected override void OnAppearing()
		//{
		//	base.OnAppearing();

		//	
		//	MessagingCenter.Send(this, "allowPortrait");
		//}
	}
}
