using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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

        /*private async void OnItemSelected(object sender, SelectedItemChangedEventArgs args)
        {
            var citizen = args.SelectedItem as GirafUserDTO;
            if (citizen == null)
                return;
            
            // Manually deselect item
            CitizensListView.SelectedItem = null;
        }*/

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