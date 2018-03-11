using System;
using System.Collections.Generic;
using System.Linq;
using IO.Swagger.Model;

namespace WeekPlanner.ViewModels
{
    public class ChooseCitizenViewModel : BaseViewModel
    {
        public IEnumerable<GirafUserDTO> Citizens { get; set; }
        public string Username { get; set; }
        public ChooseCitizenViewModel(IEnumerable<GirafUserDTO> citizens)
        {
            Citizens = citizens;
        }
    }
}
