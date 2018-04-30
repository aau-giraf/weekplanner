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
using System.Threading.Tasks;

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

        public ICommand SearchCommand => new MutexCommand<string>(async searchTerm => await OnSearchGetPictograms(searchTerm));
        public ICommand ItemTappedCommand => new MutexCommand<PictogramDTO>((tappedItem) => ListViewItemTapped((PictogramDTO)tappedItem));

        async void ListViewItemTapped(PictogramDTO tappedItem){
            await NavigationService.PopAsync(tappedItem);
        }

        // TODO: Implement message for no results and add a loading icon
        public Task OnSearchGetPictograms(String searchTerm)
        {
            return _requestService.SendRequestAndThenAsync(
                requestAsync: () => _pictogramApi.V1PictogramGetAsync(1, 10, searchTerm),
                onSuccess: result => { ImageSources = new ObservableCollection<PictogramDTO>(result.Data); });
        }
    } 
}