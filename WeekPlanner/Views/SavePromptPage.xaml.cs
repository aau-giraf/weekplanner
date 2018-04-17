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

            MessagingCenter.Subscribe<SavePromptViewModel, string>(this, MessageKeys.ScheduleNotSavedPrompt,
                async (sender, message) =>
                    await DisplayAlert ("Forlad ugeplanen?", message, "Gem ikke", "Gem ændringer"));
        }
	}
}