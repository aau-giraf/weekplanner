using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Model;
using WeekPlanner.Services;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Request;
using WeekPlanner.Services.Settings;

namespace WeekPlanner.ViewModels
{
    public class WeekPlannerTemplateViewModel : WeekPlannerViewModel
    {
        
        private readonly IWeekTemplateApi _weekTemplateApi;
        private WeekTemplateDTO _weekTemplate;
        
        public WeekPlannerTemplateViewModel(INavigationService navigationService, IRequestService requestService, 
            IWeekApi weekApi, IDialogService dialogService, ISettingsService settingsService, 
            IPictogramApi pictogramApi, IWeekTemplateApi weekTemplateApi) : 
            base(navigationService, requestService, weekApi, dialogService, settingsService, 
                pictogramApi)
        {
            _weekTemplateApi = weekTemplateApi;
            ShowToolbarButton = false;
            
            
        }


        protected override async Task SaveOrUpdateSchedule()
        {
            PutChoiceActivitiesBackIntoSchedule();
            
            CreateTemplateFromWeek();

            await RequestService.SendRequestAndThenAsync(
                () => _weekTemplateApi.V1WeekTemplatePostAsync(_weekTemplate),
                result =>
                {
                    DialogService.ShowAlertAsync(message: string.Format("Skabelonen blev gemt", result.Data.Name));
                });
            
            FoldDaysToChoiceBoards();
        }
        
        private void CreateTemplateFromWeek()
        {
            _weekTemplate.Days.Clear();
            foreach (var day in WeekDTO.Days)
            {
                _weekTemplate.Days.Add(day);
            }

            _weekTemplate.Name = WeekDTO.Name;
        }

        protected override async Task<bool> SaveDialog(bool showDialog)
        {
            return !showDialog || await DialogService.ConfirmAsync(
                       title: "Gem skabelon",
                       message: "Vil du gemme skabelonen?",
                       okText: "Gem",
                       cancelText: "Annuller");
        }
        
        private void SetTemplateToWeek()
        {
            WeekDTO = new WeekDTO
            {
                Name = _weekTemplate.Name,
                Days = new List<WeekdayDTO>()
            };
            WeekDTO.Days.AddRange(_weekTemplate.Days);
            WeekDTO.Name = _weekTemplate.Name;
        }

        protected override async Task ShowWeekNameEmptyPrompt()
        {
            await DialogService.ShowAlertAsync("Giv venligst skabelonen et navn, og gem igen.", "Ok",
                "Skabelonen blev ikke gemt");
        }

        public override async Task InitializeAsync(object navigationData)
        {
            
            if (navigationData is WeekTemplateDTO weekTemplateDTO)
            {
                SaveText = "Gem Skabelon";
                _weekTemplate = weekTemplateDTO;
                SetTemplateToWeek();
                await NavigationService.RemoveLastFromBackStackAsync();
            }
            else
            {
                throw new ArgumentException("Should always be of type WeekTemplateDTO", nameof(navigationData));
            }
            
            SaveText = "Gem Skabelon";
            ToggleDaysAndOrderActivities();
        }
    }
}