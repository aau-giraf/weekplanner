using IO.Swagger.Api;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class CitizenSchedulesViewModel : ViewModelBase
    {
        private readonly IWeekApi _weekApi;
        private readonly IPictogramApi _pictogramApi;
        private readonly ILoginService _loginService;

        public ICommand CitizenSchedulesCommand => new Command(() => CitizenSchedules());

        private ObservableCollection<ImageSource> _items = new ObservableCollection<ImageSource>();
        public ObservableCollection<ImageSource> Items
        {
            get { return _items; }
        }


        private async Task CitizenSchedules()
        {
            ImageSource img = ImageSource.FromFile("icon.png");
            Items.Add(img);
        }

        public CitizenSchedulesViewModel(INavigationService navigationService) : base(navigationService)
        {

        }
    }
}
