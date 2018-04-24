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
		}

        override protected void OnAppearing()
        {
            base.OnAppearing();
            MessagingCenter.Send(this, "allowPortrait");
        }

        protected override void OnDisappearing()
        {
            base.OnDisappearing();
            MessagingCenter.Send(this, "forceLandscape");
        }

    }

}
