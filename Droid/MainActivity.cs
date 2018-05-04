using Acr.UserDialogs;
using Android.App;
using Android.Content.PM;
using Android.OS;
using Android.Views;
using FFImageLoading.Forms.Droid;
using Xamarin.Forms;
using WeekPlanner.Views;

namespace WeekPlanner.Droid
{
    [Activity(Label = "Giraf Ugeplan", Icon = "@drawable/icon", Theme = "@style/MyTheme", MainLauncher = true, ConfigurationChanges = ConfigChanges.ScreenSize | ConfigChanges.Orientation, ScreenOrientation = ScreenOrientation.Landscape)]
    public class MainActivity : global::Xamarin.Forms.Platform.Android.FormsAppCompatActivity
    {
        protected override void OnCreate(Bundle bundle)
        {
            TabLayoutResource = Resource.Layout.Tabbar;
            ToolbarResource = Resource.Layout.Toolbar;

			base.OnCreate(bundle);
            
            Forms.Init(this, bundle);
            
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
