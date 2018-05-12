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
		
		//public override UIInterfaceOrientationMask GetSupportedInterfaceOrientations(UIApplication application, [Transient] UIWindow forWindow)
		//{
		//	MessagingCenter.Subscribe<WeekPlannerViewModel, string>(this, "SetOrientation", (m, orientation) => 
		//	{
		//		switch (orientation)
		//		{
		//			case "Landscape":
		//				RequestedOrientation = ScreenOrientation.Landscape;
		//				break;
		//			case "Portrait":
		//				RequestedOrientation = ScreenOrientation.Portrait;
		//				break;
		//			default:
		//				return UIInterfaceOrientationMask.LandscapeRight;

		//		}
		//	});
			
			
		//}

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
