using System;
using System.IO;
using System.Net;
using System.Text;
using IO.Swagger.Model;
using System.Threading.Tasks;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using WeekPlanner.Services.Navigation;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Windows.Input;
using System.Linq;
using Xamarin.Forms.Internals;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;


namespace WeekPlanner.ViewModels
{
    
    public class PictogramSearchViewModel : ViewModelBase
    {
        
        public PictogramSearchViewModel(INavigationService navigationService) : base(navigationService)
        {
            
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

        //Command der kalder metoden onSearchGetPictogram. 
        //Variablen 'searchTerm' er binded til SearchCommandParameter i PictogramSearchPage.
        public ICommand SearchCommand => new Command((searchTerm) => onSearchGetPictograms((String)searchTerm));


        //Command der kalder metoden 'ListViewItemTapped når man trykker på et billede i PictoSearch,
        //tager det PictogramDTO man trykker på, som input.
        //Variablen 'tappedItem' er binded til FlowLastTappedItem i PictogramSearchPage. 
        public ICommand ItemTappedCommand => new Command((tappedItem) => ListViewItemTapped((PictogramDTO)tappedItem));



        //Metode som kaldes når man trykker på billede i PictoSearch, og sender en PictrogramDTO til messagecenter
        //således at andre view kan subscribe til den pågældende pictogramDTO. 
        //For eksempel hvis jeg skal bruge et billede til WeekSchedule, så kan jeg tilgå billedet i det pågældende
        //view ved at subscribe til den messagekey der hedder 'PictoSearchChosenItem'.
        //På den måde kommunikerer man mellem views.
        async void ListViewItemTapped(PictogramDTO tappedItem){
            MessagingCenter.Send(this, MessageKeys.PictoSearchChosenItem, tappedItem);
            await NavigationService.PopAsync();
        }

        //HUSK AT IMPLEMENTERE BESKED VED INGEN RESULTATER OG LOADING ICON
        public void onSearchGetPictograms(String searchTerm)
        {
            ImageSources = new ObservableCollection<PictogramDTO>();

            String apiUrl = GlobalSettings.DefaultEndpoint + @"/v1/pictogram?q=" + searchTerm + @"&p=1&n=30";
            var jsonResponseString = new WebClient().DownloadString(apiUrl);
            ResponseListPictogramDTO jsonResult = JsonConvert.DeserializeObject<ResponseListPictogramDTO>(jsonResponseString);

            if(jsonResult.Data.Count != 0){
                foreach (PictogramDTO pictogramDTO in jsonResult.Data)
                {
                    ImageSources.Add(pictogramDTO);
                }
            }
            else{
                //Sæt en eller anden label, der fortæller at der ikke søgeresultat var.
            }
        }
    }
}