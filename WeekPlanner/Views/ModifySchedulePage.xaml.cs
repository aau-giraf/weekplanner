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
            //Save.Command.Execute(null);  
            DisplayAlert("Gem ugeplan", "Vil du gemme ugeplanen?", "Gem", "Luk");
        }
    }
}
