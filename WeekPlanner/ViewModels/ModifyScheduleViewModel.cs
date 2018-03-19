using System;
using System.IO;
using System.Net;
using System.Text;
using IO.Swagger.Model;
using System.Threading.Tasks;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using WeekPlanner.Services.Navigation;
using System.Windows.Input;

namespace WeekPlanner.ViewModels
{
    public class ModifyScheduleViewModel : ViewModelBase
    {
        /*
        public ModifyScheduleViewModel(INavigationService navigationService, Week schedule) : base(navigationService)
        {
            //TODO: input the schedules activities within the view
        }
        */

        public ModifyScheduleViewModel(INavigationService navigationService) : base(navigationService)
        {
            
        }

    }
}
