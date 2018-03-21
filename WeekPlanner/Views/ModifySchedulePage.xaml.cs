using System;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;


namespace WeekPlanner.Views
{

    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ModifySchedulePage : ContentPage
    {
        public ModifySchedulePage()
        {
            InitializeComponent();
        }


        private async void Save_OnClicked(object sender, EventArgs e)
        {
            bool result = await DisplayAlert("Gem ugeplan", "Vil du gemme ugeplanen?", "Gem", "Annuller");
            if(result)
            {
                MessagingCenter.Send(this, MessageKeys.ScheduleSaveRequest);
            }
        }
    }
}
