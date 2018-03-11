using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WeekPlanner.ViewModels;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace WeekPlanner.Views
{

    [XamlCompilation(XamlCompilationOptions.Compile)]
	public partial class WeekPlannerPage : ContentPage
	{
        WeekPlannerViewModel viewModel;

        public WeekPlannerPage(WeekPlannerViewModel viewModel)
		{
			InitializeComponent();
            BindingContext = this.viewModel = viewModel;
		}
	}
}
