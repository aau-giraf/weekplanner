using Xamarin.Forms;

namespace WeekPlanner.Views
{
    public class MainPage : TabbedPage
    {
        public MainPage()
        {
            
        }

        protected override void OnCurrentPageChanged()
        {
            base.OnCurrentPageChanged();
            Title = CurrentPage?.Title ?? string.Empty;
        }
    }
}
