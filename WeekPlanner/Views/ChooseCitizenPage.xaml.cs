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
                CitizensListView.ItemsSource = vm.Citizens.Where(x => x.Username.StartsWith(e.NewTextValue, System.StringComparison.InvariantCultureIgnoreCase));

        }

        void Handle_ItemSelected(object sender, SelectedItemChangedEventArgs e)
        {
            ((ListView)sender).SelectedItem = null;
        }
    }
}