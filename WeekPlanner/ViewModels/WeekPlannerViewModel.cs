using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Text;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.ViewModels
{
    public class WeekPlannerViewModel : BaseViewModel
    {
        public GirafUserDTO Citizen { get; set; }
        public WeekPlannerViewModel(GirafUserDTO citizen)
        {
            Title = "Ugeplan";
            Citizen = citizen;
        }
    }
}
