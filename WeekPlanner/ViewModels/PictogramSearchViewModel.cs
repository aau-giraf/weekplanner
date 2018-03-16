using System;
using System.IO;
using System.Net;
using System.Text;
using IO.Swagger.Model;
using System.Threading.Tasks;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using WeekPlanner.Services.Navigation;

namespace WeekPlanner.ViewModels
{
    public class PictogramSearchViewModel : ViewModelBase
    {
        public PictogramSearchViewModel(INavigationService navigationService) : base(navigationService)
        {
            
        }
    }
}
