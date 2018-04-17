using FFImageLoading.Forms.Touch;
using Foundation;
using ObjCRuntime;
using UIKit;
using WeekPlanner.Views;

namespace WeekPlanner.iOS
{
    [Register("AppDelegate")]
    public partial class AppDelegate : global::Xamarin.Forms.Platform.iOS.FormsApplicationDelegate
    {
		public override UIInterfaceOrientationMask GetSupportedInterfaceOrientations(UIApplication application, [Transient] UIWindow forWindow)
		{
			var mainPage = Xamarin.Forms.Application.Current.MainPage;
			var last = mainPage.Navigation.NavigationStack.Count - 1;

			if (mainPage.Navigation.NavigationStack[last] is WeekPlannerPage)
			{
				return UIInterfaceOrientationMask.AllButUpsideDown;
			}

			return UIInterfaceOrientationMask.Portrait;
		}

		public override bool FinishedLaunching(UIApplication app, NSDictionary options)
        {
            global::Xamarin.Forms.Forms.Init();
            CachedImageRenderer.Init();
            
            LoadApplication(new App());
            return base.FinishedLaunching(app, options);
        }


    }
}
