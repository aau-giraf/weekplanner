using System;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using WeekPlanner.ViewModels;
using WeekPlanner.ViewModels.Base;
using WeekPlanner.Views;
using Xamarin.Forms;

namespace WeekPlanner.Services.Navigation
{
    public class NavigationService : INavigationService
    {
        public ViewModelBase PreviousPageViewModel
        {
            get
            {
                var mainPage = Application.Current.MainPage as CustomNavigationPage;
                var viewModel = mainPage.Navigation.NavigationStack[mainPage.Navigation.NavigationStack.Count - 2].BindingContext;
                return viewModel as ViewModelBase;
            }
        }

        public Task InitializeAsync()
        {
            return NavigateToAsync<TestingViewModel>();
            
            // TODO: Remember chosen department and maybe authtoken
            /*if (string.IsNullOrEmpty(GlobalSettings.Instance.AuthToken))
            {
                return NavigateToAsync<TestingViewModel>();
            }
            else
            {
                return NavigateToAsync<ChooseCitizenViewModel>();
            }*/
        }
        
        /// <summary>
        /// Pops the current page unless it is the frontpage of the app
        /// </summary>
        /// <returns></returns>
        public Task PopAsync()
        {
            var navigationPage = Application.Current.MainPage as CustomNavigationPage;
            
            // TODO: Update to use correct frontpage
            if (!(navigationPage?.Navigation.NavigationStack.Last() is TestingPage))
            {
                return navigationPage?.PopAsync();
            }
            return Task.FromResult(false);
        }

        public Task NavigateToAsync<TViewModel>(object parameter = null) where TViewModel : ViewModelBase
        {
            return InternalNavigateToAsync(typeof(TViewModel), parameter);
        }

        public Task RemoveLastFromBackStackAsync()
        {
            var mainPage = Application.Current.MainPage as CustomNavigationPage;

            mainPage?.Navigation.RemovePage(
                mainPage.Navigation.NavigationStack[mainPage.Navigation.NavigationStack.Count - 2]);

            return Task.FromResult(true);
        }

        public Task RemoveBackStackAsync()
        {
            if (Application.Current.MainPage is CustomNavigationPage mainPage)
            {
                for (int i = 0; i < mainPage.Navigation.NavigationStack.Count - 1; i++)
                {
                    var page = mainPage.Navigation.NavigationStack[i];
                    mainPage.Navigation.RemovePage(page);
                }
            }

            return Task.FromResult(true);
        }

        private async Task InternalNavigateToAsync(Type viewModelType, object parameter)
        {
            Page page = CreatePage(viewModelType, parameter);

            if (page is TestingPage)
            {
                Application.Current.MainPage = new CustomNavigationPage(page);
            }
            else
            {
                if (Application.Current.MainPage is CustomNavigationPage navigationPage)
                {
                    await navigationPage.PushAsync(page);
                }
                else
                {
                    Application.Current.MainPage = new CustomNavigationPage(page);
                }
            }

            if (page.BindingContext is ViewModelBase vmBase)
            {
                await vmBase.InitializeAsync(parameter);
            }
            else
            {
                throw new Exception($"{page.BindingContext} does not inherit ViewModelBase");
            }
            
        }

        private Page CreatePage(Type viewModelType, object parameter)
        {
            Type pageType = GetPageTypeForViewModel(viewModelType);
            if (pageType == null)
            {
                throw new Exception($"Cannot locate page type for {viewModelType}");
            }

            Page page = Activator.CreateInstance(pageType) as Page;
            return page;
        }

        private Type GetPageTypeForViewModel(Type viewModelType)
        {
            var viewName = viewModelType.FullName.Replace("ViewModels", "Views").Replace("ViewModel", "Page");
            var viewModelAssemblyName = viewModelType.GetTypeInfo().Assembly.FullName;
            var viewAssemblyName = string.Format(CultureInfo.InvariantCulture, "{0}, {1}", viewName, viewModelAssemblyName);
            var viewType = Type.GetType(viewAssemblyName);
            return viewType;
        }


    }
}
