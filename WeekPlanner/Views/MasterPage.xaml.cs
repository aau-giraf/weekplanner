using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.Views
{
	[XamlCompilation(XamlCompilationOptions.Compile)]
	public partial class MasterPage : MasterDetailPage
	{
        public MasterPage()
        {
            InitializeComponent();
            Detail = new CustomNavigationPage(new LoginPage());
            MessagingCenter.Subscribe<MasterViewModel>(this, MessageKeys.HideMasterPage, sender => { IsPresented = false; });
        }


	}
}