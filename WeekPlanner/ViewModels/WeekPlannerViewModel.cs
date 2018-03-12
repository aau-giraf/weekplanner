using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Text;
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

        public override Task InitializeAsync(object navigationData)
        {
            if (navigationData is GirafUserDTO citizen)
            {
                Citizen = citizen;
            }
            return Task.Delay(1);
        }
    }
}
