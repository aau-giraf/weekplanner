using FFImageLoading.Forms.Touch;
using Foundation;
using ObjCRuntime;
using Syncfusion.ListView.XForms.iOS;
using UIKit;
using WeekPlanner.ViewModels;
using Xamarin.Forms;

namespace WeekPlanner.iOS
{
	[Register("AppDelegate")]
	public partial class AppDelegate : global::Xamarin.Forms.Platform.iOS.FormsApplicationDelegate
    {
		private UIInterfaceOrientationMask Orientation = UIInterfaceOrientationMask.Landscape;
		public override UIInterfaceOrientationMask GetSupportedInterfaceOrientations(UIApplication application, [Transient] UIWindow forWindow)
		{
			MessagingCenter.Subscribe<WeekPlannerViewModel, string>(this, "SetOrientation", (m, orientation) =>
			{
				switch (orientation)
				{
					case "Landscape":
						Orientation = UIInterfaceOrientationMask.LandscapeRight;
						break;
					case "Portrait":
						Orientation = UIInterfaceOrientationMask.Portrait;
						break;
					default:
						Orientation = UIInterfaceOrientationMask.LandscapeRight;
						break;

				}
			});

			return Orientation;
		}

		public override bool FinishedLaunching(UIApplication app, NSDictionary options)
        {
            Xamarin.Forms.Forms.Init();
            CachedImageRenderer.Init();
            
	        SfListViewRenderer.Init();
	        
            LoadApplication(new App());
            return base.FinishedLaunching(app, options);
        }


    }
}
