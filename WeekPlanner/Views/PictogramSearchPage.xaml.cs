using WeekPlanner.Views.Base;
using Xamarin.Forms.Xaml;

namespace WeekPlanner.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class PictogramSearchPage : PageBase
    {
        public PictogramSearchPage()
        {
            InitializeComponent(); 
            searchField.Focus();
        }
    }
}
