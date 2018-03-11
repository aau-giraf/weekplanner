using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using IO.Swagger.Model;

namespace WeekPlanner.ViewModels
{
    public class ChooseCitizenViewModel : BaseViewModel
    {
        public ObservableCollection<GirafUserDTO> Citizens { get; set; }
        public string Username { get; set; }
        public ChooseCitizenViewModel(IEnumerable<GirafUserDTO> citizens)
        {
            Title = "Vælg bruger";
            Citizens = new ObservableCollection<GirafUserDTO>(citizens);
        }
    }
}
