using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace WeekPlanner.Views
{
	[XamlCompilation(XamlCompilationOptions.Compile)]
	public partial class SavePromptPage : ContentPage
	{
		public SavePromptPage ()
		{
			InitializeComponent ();
            
        }

        protected override bool OnBackButtonPressed()
        {
            MessagingCenter.Send(this, MessageKeys.BackButtonPressed);

            return true;
        }
    }
}