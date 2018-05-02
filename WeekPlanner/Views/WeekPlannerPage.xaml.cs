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

        protected override bool OnBackButtonPressed()
        {
            var vm = BindingContext as WeekPlannerViewModel;

            vm.OnBackButtonPressedCommand.Execute(null);

            return true;
        }
    }
}
