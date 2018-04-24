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
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class NewScheduleViewModel : Base.ViewModelBase
    {
        private WeekDTO _weekDTO = new WeekDTO();
        private IWeekApi _weekApi;
        private IPictogramApi _pictogramApi;
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

        public ICommand SaveWeekScheduleCommand => new Command(() => SaveWeekSchedule());
        public ICommand ChangePictogramCommand => new Command(() => ChangePictogram());

        public NewScheduleViewModel(INavigationService navigationService, IWeekApi weekApi, IPictogramApi pictogramApi) : base(navigationService)
        {
            _weekApi = weekApi;
            _pictogramApi = pictogramApi;

            _weekDTO.Thumbnail = _pictogramApi.V1PictogramByIdGet(2).Data;
            WeekThumbNail = _weekDTO.Thumbnail;

            _scheduleName = new ValidatableObject<string>(new IsNotNullOrEmptyRule<string> { ValidationMessage = "Et navn er påkrævet." });
        }


        private void ChangePictogram()
        {
            NavigationService.NavigateToAsync<PictogramSearchViewModel>();
            MessagingCenter.Subscribe<PictogramSearchViewModel, PictogramDTO>(this, MessageKeys.PictoSearchChosenItem,
                InsertPicto);
        }

        private void InsertPicto(PictogramSearchViewModel arg1, PictogramDTO arg2)
        {
            WeekThumbNail = arg2;
        }

        private void SaveWeekSchedule()
        {
            if (ValidateWeekScheduleName())
            {
                _weekDTO.Name = ScheduleName.Value;
                _weekDTO.Thumbnail = WeekThumbNail;

                _weekApi.V1WeekPostAsync(_weekDTO);

                NavigationService.PopAsync();
            }
        }

        public ICommand ValidateWeekNameCommand => new Command(() => _scheduleName.Validate());

        private bool ValidateWeekScheduleName()
        {
            var isWeekNameValid = _scheduleName.Validate();
            return isWeekNameValid;
        }
    }
}
