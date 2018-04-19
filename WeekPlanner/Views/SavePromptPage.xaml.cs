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

            MessagingCenter.Subscribe<SavePromptViewModel>(this, MessageKeys.ScheduleNotSavedPrompt, (sender) => DisplayPrompt());
        }

        public async void DisplayPrompt()
        {
            var result = await DisplayActionSheet("Du har ændringer der ikke er gemt. Vil du gemme?", "Annuller", null, "Gem ændringer", "Gem ikke");

            switch (result)
            {
                case "Annuller":
                    ButtonPrompt.Text = result;
                    break;

                case "Gem ikke":
                    ButtonPrompt.Text = result;
                    break;

                case "Gem ændringer":
                    ButtonPrompt.Text = result;
                    break;
            } 
        }
	}
}