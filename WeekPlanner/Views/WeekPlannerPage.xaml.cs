using Syncfusion.ListView.XForms;
using WeekPlanner.Views.Base;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.Views
{

	[XamlCompilation(XamlCompilationOptions.Compile)]
	public partial class WeekPlannerPage : PageBase
	{
		public WeekPlannerPage()
		{
			InitializeComponent();

			MessagingCenter.Subscribe<WeekPlannerViewModel, string>(this, "ChangeView", ChangeView);
		}

		private void ChangeView(WeekPlannerViewModel m, string s)
		{
			if (s == "Portrait")
			{
				MultiDayView.IsVisible = false;
				OneDayView.IsVisible = true;
			}
			else
			{
				OneDayView.IsVisible = false;
				MultiDayView.IsVisible = true;
			}
		}
	}
}