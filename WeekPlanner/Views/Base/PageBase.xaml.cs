using Xamarin.Forms;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.Views.Base
{
    public abstract partial class PageBase : ContentPage
    {
        protected PageBase()
        {
            InitializeComponent();
            NavigationPage.SetHasNavigationBar(this, false);
        }

		protected override bool OnBackButtonPressed()
        {
			var vm = BindingContext as ViewModelBase;

            vm?.OnBackButtonPressedCommand.Execute(null);

            return true;
        }
    }
}
