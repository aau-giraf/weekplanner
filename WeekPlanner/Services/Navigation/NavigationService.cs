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
                CustomNavigationPage navigationPage = GetNavigationPage();
                var navigationStack = navigationPage.Navigation.NavigationStack;

                // If we do not have a previous page, return null
                if (navigationStack.Count < 2) return null;
                
                var viewModel = navigationStack[navigationStack.Count - 2].BindingContext;
                return viewModel as ViewModelBase;
            }
        }

        public ViewModelBase CurrentPageViewModel
        {
            get
            {
                CustomNavigationPage navigationPage = GetNavigationPage();
                var viewModel = navigationPage.Navigation.NavigationStack.Last().BindingContext;
                return viewModel as ViewModelBase;
            }
        }

        public Task InitializeAsync()
        {
            return NavigateToAsync<LoginViewModel>();
        }

        public async Task PopAsync(object navigationData = null)
        {
            CustomNavigationPage navigationPage = GetNavigationPage();
            if (navigationPage != null)
            {
                if (PreviousPageViewModel is null || PreviousPageViewModel is LoginViewModel)
                {
                    // If you pop to login or beyond, simply clear stack and go to loginpage
                    await RemoveBackStackAsync();
                    await NavigateToAsync<LoginViewModel>();
                    return;
                }

                await navigationPage.PopAsync();
                await CurrentPageViewModel.PoppedAsync(navigationData);
            }
        }

        private static CustomNavigationPage GetNavigationPage()
        {
            var mainPage = Application.Current.MainPage;
            CustomNavigationPage navigationPage = null;

            switch (mainPage)
            {
                case MasterPage masterPage:
                    navigationPage = masterPage.Detail as CustomNavigationPage;
                    break;
                case CustomNavigationPage customNavigationPage:
                    navigationPage = customNavigationPage;
                    break;
            }

            return navigationPage;
        }

        public Task NavigateToAsync<TViewModel>(object parameter = null) where TViewModel : ViewModelBase
        {
            return InternalNavigateToAsync(typeof(TViewModel), parameter);
        }

        public Task RemoveLastFromBackStackAsync()
        {
            CustomNavigationPage navigationPage = GetNavigationPage();
            var navigationStack = navigationPage.Navigation.NavigationStack;
            navigationPage.Navigation.RemovePage(navigationStack[navigationStack.Count - 2]);

            return Task.FromResult(true);
        }

        public Task RemoveBackStackAsync()
        {
            CustomNavigationPage navigationPage = GetNavigationPage();
            for (int i = 0; i < navigationPage.Navigation.NavigationStack.Count - 1; i++)
            {
                var page = navigationPage.Navigation.NavigationStack[i];
                navigationPage.Navigation.RemovePage(page);
            }

            return Task.FromResult(true);
        }

        private static async Task InternalNavigateToAsync(Type viewModelType, object parameter)
        {
            Page page = CreatePage(viewModelType, parameter);

            if (page is TestingPage)
            {
                Application.Current.MainPage = new CustomNavigationPage(page);
            }
            else
            {
                var master = (MasterPage)Application.Current.MainPage;
                var detail = (CustomNavigationPage)master.Detail;
                await detail.PushAsync(page);
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

        private static Type GetPageTypeForViewModel(Type viewModelType)
        {
            var viewName = viewModelType.FullName.Replace("ViewModels", "Views").Replace("ViewModel", "Page");
            var viewModelAssemblyName = viewModelType.GetTypeInfo().Assembly.FullName;
            var viewAssemblyName = string.Format(CultureInfo.InvariantCulture, "{0}, {1}", viewName, viewModelAssemblyName);
            var viewType = Type.GetType(viewAssemblyName);
            return viewType;
        }

        private static Page CreatePage(Type viewModelType, object parameter)
        {
            Type pageType = GetPageTypeForViewModel(viewModelType);
            if (pageType == null)
            {
                throw new Exception($"Cannot locate page type for {viewModelType}");
            }

            Page page = Activator.CreateInstance(pageType) as Page;
            return page;
        }


    }
}
