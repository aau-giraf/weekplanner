using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using WeekPlanner.ViewModels;
using Xamarin.Forms;

namespace WeekPlanner.Views
{
    public partial class ChooseCitizenPage : ContentPage
    {
        ChooseCitizenViewModel viewModel;

        public ChooseCitizenPage(ChooseCitizenViewModel viewModel)
        {
            InitializeComponent();
            BindingContext = this.viewModel = viewModel;
        }

        private async void OnItemSelected(object sender, SelectedItemChangedEventArgs args)
        {
            var citizen = args.SelectedItem as GirafUserDTO;
            if (citizen == null)
                return;

            await Navigation.PushAsync(new WeekPlannerPage(new WeekPlannerViewModel(citizen)));

            // Manually deselect item
            CitizensListView.SelectedItem = null;
        }
    }
}
