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
        private List<AbsoluteLayout> _scheduleList = new List<AbsoluteLayout>();

        public CitizenSchedulesPage()
        {
            InitializeComponent();
        }

        private void OnAddSchedule(object sender, EventArgs e)
        {
            if (_scheduleList.Count < 8)
            {
                int cell = 0;

                Image scheduleImage = new Image { Source = "weekschedule.png" };
                Label scheduleLabel = new Label
                {
                    Text = "Schedule",
                    HorizontalOptions = LayoutOptions.Center,
                    TextColor = Color.Black,
                    FontSize = 20
                };

                var layout = new AbsoluteLayout()
                {
                    Padding = 20,
                    HorizontalOptions = LayoutOptions.Fill,
                    Children =
                    {
                        scheduleImage,
                        scheduleLabel
                    }
                };
                AbsoluteLayout.SetLayoutBounds(scheduleImage, new Rectangle(0, 0, 1, 1));
                AbsoluteLayout.SetLayoutFlags(scheduleImage, AbsoluteLayoutFlags.SizeProportional);

                AbsoluteLayout.SetLayoutBounds(scheduleLabel, new Rectangle(0, 0.9, 1, 0.1));
                AbsoluteLayout.SetLayoutFlags(scheduleLabel, AbsoluteLayoutFlags.All);
                //            var layout = new Image {Source = "weekschedule.png", Aspect = Aspect.Fill};

                _scheduleList.Add(layout);
                PopulateGrid(cell);
            }
            else
            {
                DisplayAlert("Fejl", "Du kan ikke indsætte mere end 8 ugeplaner", "okay");
            }
        }

        private void PopulateGrid(int cell)
        {
            foreach (var schedule in _scheduleList)
            {
                var row = cell / 4;
                var column = cell % 4;
                ScheduleGrid.Children.Add(schedule, column, row);
                cell++;
            }
        }
    }
}