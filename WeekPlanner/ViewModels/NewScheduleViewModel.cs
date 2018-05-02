using IO.Swagger.Api;
using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using WeekPlanner.Helpers;
using WeekPlanner.Services;
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

        private readonly IWeekApi _weekApi;
        private readonly IPictogramApi _pictogramApi;
        private readonly IDialogService _dialogService;
        private readonly IRequestService _requestService;

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

        private WeekPictogramDTO _weekThumbNail;

        public WeekPictogramDTO WeekThumbNail
        {
            get => _weekThumbNail;
            set
            {
                _weekThumbNail = value;
                RaisePropertyChanged(() => WeekThumbNail);
            }
        }

        public ICommand SaveWeekScheduleCommand => new Command(SaveWeekSchedule);
        public ICommand ChangePictogramCommand => new Command(ChangePictogram);

        public NewScheduleViewModel(
            INavigationService navigationService,
            IWeekApi weekApi,
            IPictogramApi pictogramApi,
            IRequestService requestService,
            IDialogService dialogService) : base(navigationService)
        {
            _weekApi = weekApi;
            _pictogramApi = pictogramApi;
            _requestService = requestService;
            _dialogService = dialogService;

            var defaultPicto = _pictogramApi.V1PictogramByIdGet(2).Data;
            WeekPictogramDTO weekPictogramDto = new WeekPictogramDTO()
            {
                Id = defaultPicto.Id,
            };

            WeekThumbNail = weekPictogramDto;

            _scheduleName =
                new ValidatableObject<string>(
                    new IsNotNullOrEmptyRule<string> {ValidationMessage = "Et navn er påkrævet."});
        }

        public override Task PoppedAsync(object navigationData)
        {
            // Happens when selecting a picto in PictoSearch
            if (navigationData is PictogramDTO pictoDTO)
            {
                WeekThumbNail.Id = pictoDTO.Id;
            }

            return Task.FromResult(false);
        }


        private void ChangePictogram()
        {
            if (IsBusy) return;
            IsBusy = true;
            NavigationService.NavigateToAsync<PictogramSearchViewModel>();
            IsBusy = false;
        }


        private async void SaveWeekSchedule()
        {
            if (IsBusy) return;
            IsBusy = true;

            if (ValidateWeekScheduleName())
            {
                _weekDTO.Name = ScheduleName.Value;
                _weekDTO.Thumbnail = WeekThumbNail;


                await _requestService.SendRequestAndThenAsync(
                    requestAsync: () =>
                        _weekApi.V1WeekByWeekYearByWeekNumberPutAsync(
                            weekNumber: Helpers.DateTimeHelper.GetIso8601WeekOfYear(DateTime.Now),
                            weekYear: DateTime.Now.Year, newWeek: _weekDTO),
                    onSuccess:
                    async result =>
                    {
                        await _dialogService.ShowAlertAsync($"Ugeplanen '{result.Data.Name}' blev oprettet og gemt.");
                        await NavigationService.PopAsync();
                    });
            }

            IsBusy = false;
        }

        public ICommand ValidateWeekNameCommand => new Command(() => _scheduleName.Validate());

        private bool ValidateWeekScheduleName()
        {
            var isWeekNameValid = _scheduleName.Validate();
            return isWeekNameValid;
        }
    }
}