using IO.Swagger.Api;
using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Input;
using WeekPlanner.Services.Login;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.Validations;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class NewScheduleViewModel : Base.ViewModelBase
    {
        private WeekDTO _weekDTO = new WeekDTO();
        private IWeekApi _weekApi;
        private ValidatableObject<string> _scheduleName;
        public ValidatableObject<string> ScheduleName
        {
            get => _scheduleName;
            set
            {
                _scheduleName = value;
                RaisePropertyChanged(() => ScheduleName);
            }
        }
        private PictogramDTO _weekThumbNail;
        public PictogramDTO WeekThumbNail
        {
            get => _weekThumbNail;
            set
            {
                _weekThumbNail = value;
                RaisePropertyChanged(() => WeekThumbNail);
            }
        }

        public ICommand AddWeekScheduleCommand => new Command(() => SaveWeekSchedule());
        public ICommand ChangePictogramCommand => new Command(() => ChangePictogram());

        public NewScheduleViewModel(INavigationService navigationService, IWeekApi weekApi) : base(navigationService)
        {
            _weekApi = weekApi;
            _scheduleName = new ValidatableObject<string>(new IsNotNullOrEmptyRule<string> { ValidationMessage = "Et navn er påkrævet." });
        }


        private void ChangePictogram()
        {
            NavigationService.NavigateToAsync<PictogramSearchViewModel>();
        }

        private void SaveWeekSchedule()
        {
            _weekDTO.Name = ScheduleName.Value;
            _weekDTO.Thumbnail = WeekThumbNail;

            _weekApi.V1WeekPost(_weekDTO);

            NavigationService.PopAsync();
        }
    }
}
