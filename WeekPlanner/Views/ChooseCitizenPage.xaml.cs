using System;
using System.Collections.Generic;
using WeekPlanner.ViewModels;
using Xamarin.Forms;

namespace WeekPlanner.Views
{
    public partial class ChooseCitizenPage : ContentPage
    {
        public ChooseCitizenPage(ChooseCitizenViewModel viewModel)
        {
            BindingContext = viewModel;
            InitializeComponent();
        }
    }
}
