using System;
using IO.Swagger.Model;
using IO.Swagger.Api;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using WeekPlanner.Services.Navigation;
using System.Collections.ObjectModel;
using System.Windows.Input;
using IO.Swagger.Client;
using WeekPlanner.Helpers;
using WeekPlanner.Services.Request;

namespace WeekPlanner.ViewModels
{
    
    public class PictogramSearchViewModel : ViewModelBase
    {

        private readonly IPictogramApi _pictogramApi;
        private readonly IRequestService _requestService;
        
        public PictogramSearchViewModel(INavigationService navigationService, IPictogramApi pictogramApi,
        IRequestService requestService) : base(navigationService)
        {
            _pictogramApi = pictogramApi;
            _requestService = requestService;
        }

        private ObservableCollection<PictogramDTO> _imageSources;
        public ObservableCollection<PictogramDTO> ImageSources
        {
            get => _imageSources;
            set
            {
                _imageSources = value;
                RaisePropertyChanged(() => ImageSources);
            }
        }

        public ICommand SearchCommand => new Command((searchTerm) => OnSearchGetPictograms((String)searchTerm));
        public ICommand ItemTappedCommand => new Command((tappedItem) => ListViewItemTapped((PictogramDTO)tappedItem));

        async void ListViewItemTapped(PictogramDTO tappedItem){
            MessagingCenter.Send(this, MessageKeys.PictoSearchChosenItem, tappedItem);
            await NavigationService.PopAsync();
        }

        // TODO: Implement message for no results and add a loading icon
        public async void OnSearchGetPictograms(String searchTerm)
        {
            await _requestService.SendRequestAndThenAsync(this,
                requestAsync: async () => await _pictogramApi.V1PictogramGetAsync(1, 10, searchTerm),
                onSuccess: result => { ImageSources = new ObservableCollection<PictogramDTO>(result.Data); });
        }
    } 
}