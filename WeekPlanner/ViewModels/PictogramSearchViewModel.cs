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
        private ObservableCollection<ImageSource> _imageSources;
        public ObservableCollection<ImageSource> ImageSources
        {
            get => _imageSources;
            set
            {
                _imageSources = value;
                RaisePropertyChanged(() => ImageSources);
            }
        }



        public ICommand SearchCommand => new Command((searchTerm) => onSearchGetPictograms((String)searchTerm));

        public PictogramSearchViewModel(INavigationService navigationService) : base(navigationService)
        {
            //ImageSources = new ObservableCollection<ImageSource>();
            //var url = new Uri("https://upload.wikimedia.org/wikipedia/commons/1/1b/Square_200x200.png");
            //ImageSource imageToAdd = ImageSource.FromFile("icon.png");
            //ImageSources.Add(imageToAdd);
        }


        //HUSK AT IMPLEMENTERE BESKED VED INGEN RESULTATER OG LOADING ICON
        public void onSearchGetPictograms(String searchTerm)
        {

            String ngrok = "http://9bde2cf5.ngrok.io/";
            String url = ngrok + "v1/pictogram?q=" + searchTerm + "&p=0&n=30";

            dynamic jsonResult = JObject.Parse(url);
                
            Console.WriteLine(jsonResult.image.toString());
            var searchResults = new ObservableCollection<ImageSource>();


            //foreach( in jsonResult){
            //    Console.WriteLine(key);
                //byte[] byteArray = Convert.FromBase64String(subset);
                //var stream = new MemoryStream(byteArray);
                //return ImageSource.FromStream(() => stream);
            //}


            //ImageSources = searchResults;
        }
    }
}
