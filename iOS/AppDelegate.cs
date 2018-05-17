using FFImageLoading.Forms.Touch;
using Foundation;
using IO.Swagger.Model;
using ObjCRuntime;
using Syncfusion.ListView.XForms.iOS;
using UIKit;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.iOS
{
	[Register("AppDelegate")]
	public partial class AppDelegate : global::Xamarin.Forms.Platform.iOS.FormsApplicationDelegate
    {
		private UIInterfaceOrientationMask _orientation = UIInterfaceOrientationMask.Landscape;
		public override UIInterfaceOrientationMask GetSupportedInterfaceOrientations(UIApplication application, [Transient] UIWindow forWindow)
		{
			MessagingCenter.Subscribe<WeekPlannerViewModel, SettingDTO.OrientationEnum>(this, MessageKeys.SetOrientation, (m, orientation) =>
			{
				switch (orientation)
				{
					case SettingDTO.OrientationEnum.Landscape:
						_orientation = UIInterfaceOrientationMask.LandscapeRight;
						break;
					case SettingDTO.OrientationEnum.Portrait:
						_orientation = UIInterfaceOrientationMask.Portrait;
						break;
					default:
						_orientation = UIInterfaceOrientationMask.LandscapeRight;
						break;

				}
			});

			return _orientation;
		}

		public override bool FinishedLaunching(UIApplication app, NSDictionary options)
        {
            Forms.Init();
            CachedImageRenderer.Init();
            
	        SfListViewRenderer.Init();
	        
            LoadApplication(new App());
            return base.FinishedLaunching(app, options);
        }


    }
}
