using FFImageLoading.Forms.Touch;
using Foundation;
using ObjCRuntime;
using Syncfusion.ListView.XForms.iOS;
using UIKit;
using WeekPlanner.Views;

namespace WeekPlanner.iOS
{
	[Register("AppDelegate")]
	public partial class AppDelegate : global::Xamarin.Forms.Platform.iOS.FormsApplicationDelegate
    {
		
		public override UIInterfaceOrientationMask GetSupportedInterfaceOrientations(UIApplication application, [Transient] UIWindow forWindow)
		{

			return UIInterfaceOrientationMask.LandscapeRight;
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
