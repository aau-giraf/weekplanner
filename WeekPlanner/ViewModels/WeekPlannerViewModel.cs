using IO.Swagger.Model;
using System.Threading.Tasks;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.ViewModels
{
    public class WeekPlannerViewModel : ViewModelBase
    {
        private GirafUserDTO _citizen;
        public GirafUserDTO Citizen
        {
            get => _citizen;
            set
            {
                _citizen = value;
                RaisePropertyChanged(() => Citizen);
            }
        }

        public WeekPlannerViewModel()
        {
            Title = "Ugeplan";
        }

        public override async Task InitializeAsync(object navigationData)
        {
            if (navigationData is GirafUserDTO citizen)
            {
                Citizen = citizen;
            }
        }
    }
}
