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
	public partial class TestingPage : ContentPage
	{
		public TestingPage ()
		{
			InitializeComponent ();
            Title = "Navigering";
		}

        private async void Login_Button_Clicked(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new LoginPage());
        }
    }
}
