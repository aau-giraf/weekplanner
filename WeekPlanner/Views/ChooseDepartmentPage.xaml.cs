using System;
using System.Collections.Generic;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.Views
{
    public partial class ChooseDepartmentPage : ContentPage
    {
        public ChooseDepartmentPage()
        {
            InitializeComponent();

            MessagingCenter.Subscribe<ChooseDepartmentViewModel, string>(this, MessageKeys.RequestFailed, 
                                                                         async (sender, errorMessage) => {
                await DisplayAlert("Fejl", errorMessage, "Luk");
            });
        }
    }
}
