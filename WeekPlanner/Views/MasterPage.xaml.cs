using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
            Detail = new CustomNavigationPage(new LoginPage());
           // IsPresented = false;
        }
    }
}