using Acr.UserDialogs;
using Android.App;
using Android.Content.PM;
using Android.OS;
using Android.Views;
using FFImageLoading.Forms.Droid;
using IO.Swagger.Model;
using Xamarin.Forms;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.Droid
{
    [Activity(Label = "Giraf Ugeplan"
              , Icon = "@drawable/icon"
              , Theme = "@style/MyTheme"
              , MainLauncher = true
              , ConfigurationChanges = ConfigChanges.ScreenSize | ConfigChanges.Orientation
              , ScreenOrientation = ScreenOrientation.Landscape
              , LaunchMode = LaunchMode.SingleInstance)]
    public class MainActivity : global::Xamarin.Forms.Platform.Android.FormsAppCompatActivity
    {
		private void ChangeOrientation(WeekPlannerViewModel m, SettingDTO.OrientationEnum orientation)
		{
			switch (orientation)
			{
				case SettingDTO.OrientationEnum.Landscape:
					RequestedOrientation = ScreenOrientation.Landscape;
					break;
				case SettingDTO.OrientationEnum.Portrait:
					RequestedOrientation = ScreenOrientation.Portrait;
					break;
				default:
					RequestedOrientation = ScreenOrientation.Landscape;
					break;
			}
		}

		protected override void OnCreate(Bundle savedInstanceState)
        {
			MessagingCenter.Subscribe<WeekPlannerViewModel, SettingDTO.OrientationEnum>(this, MessageKeys.SetOrientation, ChangeOrientation);
            TabLayoutResource = Resource.Layout.Tabbar;
            ToolbarResource = Resource.Layout.Toolbar;

			base.OnCreate(savedInstanceState);
            
            Forms.Init(this, savedInstanceState);
            
            // Load ffimageloading
            CachedImageRenderer.Init(enableFastRenderer: true);

            // Load Acr.UserDialogs
            UserDialogs.Init(this);
            
            LoadApplication(new App());
            
            // Does so the on-screen keyboard does not hide custom navigation bar
            Window.SetSoftInputMode(SoftInput.AdjustResize);
            
            Window.AddFlags(WindowManagerFlags.Fullscreen);
            
        }
    }
}
