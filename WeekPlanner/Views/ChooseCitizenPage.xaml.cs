using System.Linq;
using WeekPlanner.ViewModels;
using WeekPlanner.Views.Base;
using Xamarin.Forms;

namespace WeekPlanner.Views
{
    public partial class ChooseCitizenPage : PageBase
    {
        public ChooseCitizenPage()
        {
            InitializeComponent();
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
