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

namespace WeekPlanner.ViewModels
{
    public class PictogramSearchViewModel : ViewModelBase
    {
        private ObservableCollection<ImageSource> _imageSources;
        public ObservableCollection<ImageSource> ImageSources
        {
            get
            {
                var imageSources = new ObservableCollection<ImageSource>();

                //ImageSource f = ImageSource.FromResource("drawable");

                for (int i = 0; i < 100; i++)
                {
                    var imageSource = ImageSource.FromFile("add_to_cart.png");
                    imageSources.Add(imageSource);
                 }
                return imageSources;
            }
            set
            {
                _imageSources = value;
                RaisePropertyChanged(() => ImageSources);
            }
        }

        public string SearchTerm
        {
            get;
            set;
        }


        public string output
        {
            get => _output;
            set
            {
                _output = value;
                RaisePropertyChanged(() => output);
            }
        }
        private string _output;


        public ICommand SearchCommand => new Command(() => onSearchGetPictograms());

        public PictogramSearchViewModel(INavigationService navigationService) : base(navigationService)
        {
            //ImageSources = new ObservableCollection<ImageSource>();
            //var url = new Uri("https://upload.wikimedia.org/wikipedia/commons/1/1b/Square_200x200.png");
            //ImageSource imageToAdd = ImageSource.FromFile("icon.png");
            //ImageSources.Add(imageToAdd);
        }

        public void onSearchGetPictograms()
        {
            //var imgSource = "https://upload.wikimedia.org/wikipedia/commons/1/1b/Square_200x200.png";
            //for (int i = 0; i < 10; i++){
            //        ImageSources.Add("icon.png");


        }
    }
}
