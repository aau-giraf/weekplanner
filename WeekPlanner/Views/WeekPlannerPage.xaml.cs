using System.ComponentModel;
using IO.Swagger.Model;
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

			MessagingCenter.Subscribe<WeekPlannerViewModel, SettingDTO.OrientationEnum>(this, MessageKeys.ChangeView, ChangeView);
		}

		private void ChangeView(WeekPlannerViewModel m, SettingDTO.OrientationEnum s)
		{
			switch (s)
			{
				case SettingDTO.OrientationEnum.Portrait:
					MultiDayView.IsVisible = false;
					OneDayView.IsVisible = true;
                    break;
				case SettingDTO.OrientationEnum.Landscape:
					MultiDayView.IsVisible = true;
					OneDayView.IsVisible = false;
                   break;
				default:
					throw new InvalidEnumArgumentException();
			}
		}
	}
}