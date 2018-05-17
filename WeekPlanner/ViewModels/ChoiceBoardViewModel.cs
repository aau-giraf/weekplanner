using System;
using IO.Swagger.Model;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using WeekPlanner.Services.Settings;
using static IO.Swagger.Model.ActivityDTO;
using System.Linq;
using WeekPlanner.Annotations;
using WeekPlanner.Helpers;
using WeekPlanner.Services;

namespace WeekPlanner.ViewModels
{
    public class ChoiceBoardViewModel : ViewModelBase
    {
        #region Properties

        public readonly ISettingsService SettingsService;
        private readonly IDialogService _dialogService;

        private int? _order;
        private ActivityDTO _activityChanged;
        private bool _newChoiceBoard;
        public ObservableCollection<ActivityDTO> ActivityDTOs { get; }

        [UsedImplicitly]
        public bool IsInCitizenMode
        {
            get => !SettingsService.IsInGuardianMode;
        }

        [UsedImplicitly]
        public ICommand FlowItemDeletedCommand => new Command(tappedItem =>
        {
            if (tappedItem is ActivityDTO tapped && SettingsService.IsInGuardianMode)
            {
                ActivityDTOs.Remove(tapped);
            }
        });

        [UsedImplicitly]
        public ICommand FlowItemTappedCommand => new Command(async (tappedItem) =>
        {
            if (!SettingsService.IsInGuardianMode && tappedItem is ActivityDTO item)
            {
                await NavigationService.PopAsync(new ObservableCollection<ActivityDTO> { item });
            }
        });

        [UsedImplicitly] public ICommand SaveChoiceCommand => new Command(async () => await SaveChoiceBoard());

        [UsedImplicitly] public ICommand DeleteActivityCommand => new Command(async () => await DeleteChoiceBoard());

        [UsedImplicitly] public ICommand AddActivityCommand => new Command(async () => await NavigationService.NavigateToAsync<PictogramSearchViewModel>());
        #endregion
        
        public ChoiceBoardViewModel(INavigationService navigationService, ISettingsService settingsService, IDialogService dialogService) : base(navigationService)
        {
            _dialogService = dialogService;
            SettingsService = settingsService;
            ActivityDTOs = new ObservableCollection<ActivityDTO>();
        }

        private void InsertPicto(WeekPictogramDTO weekPictogramDTO)
        {
            ActivityDTOs.Add(new ActivityDTO(weekPictogramDTO, _order, StateEnum.Normal));
        }
        
        private async Task DeleteChoiceBoard()
        {
            if (IsBusy) return;
            IsBusy = true;
            await NavigationService.PopAsync((_activityChanged, MessageKeys.DeleteChoiceBoard));
            IsBusy = false;
        }

        private async Task SaveChoiceBoard()
        {
            if (IsBusy) return;         

            IsBusy = true;

            if (ActivityDTOs.Count == 0)
            {
                var deleteChosen = await _dialogService.ConfirmAsync("Hvad vil du gøre?", "Der er ingen aktiviteter", "Annuller gemning",
                    "Slet valgmuligheds-aktivitet");
                IsBusy = false;
                if (deleteChosen)
                {
                    await DeleteChoiceBoard();
                }
                return;
            }
            
            if (_newChoiceBoard)
            {
                await NavigationService.PopAsync((_activityChanged, ActivityDTOs, MessageKeys.NewChoiceBoard));
            }
            else
            {
                await NavigationService.PopAsync((_activityChanged, ActivityDTOs, MessageKeys.UpdateChoiceBoard));
            }

            IsBusy = false;
        }

        public override async Task OnReturnedToAsync(object navigationData)
        {
            // Happens after choosing a pictogram in Pictosearch
            if (navigationData is WeekPictogramDTO weekPictogramDTO)
            {
                InsertPicto(weekPictogramDTO);
            }
            else if(navigationData != null)
            {
                throw new ArgumentException("Should be of type WeekPictogramDTO", nameof(navigationData));
            }
        }

        public override async Task InitializeAsync(object navigationData)
        {
            switch (navigationData)
            {
                case ActivityDTO activity:
                    // When making an activity into a choiceboard
                    _activityChanged = activity;
                    _newChoiceBoard = true;
                    _order = activity.Order;
                    ActivityDTOs.Add(activity);
                    await NavigationService.RemoveLastFromBackStackAsync();
                    break;
                case ValueTuple<ActivityDTO, List<ActivityDTO>> tuple:
                    // When editing a choiceboard
                    _activityChanged = tuple.Item1;
                    var activities = tuple.Item2;
                    _order = activities.FirstOrDefault()?.Order 
                             ?? throw new ArgumentException("Should never be empty.", nameof(activities));
                    ActivityDTOs.AddRange(activities);
                    break;
                default:
                    throw new ArgumentException("Should be either of type ActivityDTO or List<ActivityDTO>.",
                        nameof(navigationData));
            }
        }
    }
}
