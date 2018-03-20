using System;
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

        private void Save_OnClicked(object sender, EventArgs e)
        {
            DisplayAlert("Gem ugeplan", "Du gemte ugeplanen", "Luk");
        }
    }
}
