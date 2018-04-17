using System.Linq;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.Views
{
    public partial class ChooseCitizenPage : ContentPage
    {
        public ChooseCitizenPage()
        {
            InitializeComponent();

            MessagingCenter.Subscribe<ChooseCitizenViewModel, string>(this, MessageKeys.RequestFailed,
                async (sender, message) =>
                    await DisplayAlert("Fejl", message, "Luk"));
        }

        private void SearchBar_TextChanged(object sender, TextChangedEventArgs e)
        {
            var vm = BindingContext as ChooseCitizenViewModel;

            if (string.IsNullOrWhiteSpace(e.NewTextValue))
            {
                CitizensListView.ItemsSource = vm?.CitizenNames;
            }
            else
            {
                CitizensListView.ItemsSource =
                    vm?.CitizenNames.Where(x => x.UserName.ToLower().StartsWith(e.NewTextValue.ToLower()));
            }
        }
    }
}
