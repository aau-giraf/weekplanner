using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.Common;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Runtime.CompilerServices;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using WeekPlanner.ViewModels;
using Xamarin.Forms;
using Xamarin.Forms.Internals;
using Xamarin.Forms.Xaml;

namespace WeekPlanner.Views
{
    public partial class CitizenSchedulesPage : ContentPage
    {
        public CitizenSchedulesPage()
        {
            InitializeComponent();
            MessagingCenter.Subscribe<CitizenSchedulesViewModel>(this, "DeleteWeekAlert", (sender) => AlertUserDeleteWeek());
        }

        private void AlertUserDeleteWeek()
        {
            DisplayAlert("Slet Ugeplan", "Vil du slette denne ugeplan?", "Ok", "Annuller");
        }
    }
}