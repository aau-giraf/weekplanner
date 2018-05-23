using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace WeekPlanner.Views
{
	[XamlCompilation(XamlCompilationOptions.Compile)]
	public partial class MasterPage : MasterDetailPage
	{
		public MasterPage()
		{
			InitializeComponent();
			Detail = new CustomNavigationPage(new TestingPage());
		}


	}
}