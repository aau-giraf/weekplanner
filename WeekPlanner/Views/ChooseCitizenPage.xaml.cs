using System.Linq;
using WeekPlanner.ViewModels;
using Xamarin.Forms;

namespace WeekPlanner.Views
{
    public partial class ChooseCitizenPage : ContentPage
    {
        public ChooseCitizenPage()
        {
            InitializeComponent();
        }

        private void SearchBar_TextChanged(object sender, TextChangedEventArgs e)
        {
            var vm = BindingContext as ChooseCitizenViewModel;

            if (string.IsNullOrWhiteSpace(e.NewTextValue))

                CitizensListView.ItemsSource = vm.Citizens;
            else
                CitizensListView.ItemsSource = vm.Citizens.Where(x => x.Username.ToLower().StartsWith(e.NewTextValue.ToLower()));

        }
    }
}