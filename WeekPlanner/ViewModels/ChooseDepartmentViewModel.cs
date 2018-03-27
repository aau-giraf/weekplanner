using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using WeekPlanner.Helpers;
using WeekPlanner.Services.Navigation;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class ChooseDepartmentViewModel : ViewModelBase
    {
        private IDepartmentApi _departmentApi;

        public ChooseDepartmentViewModel(IDepartmentApi departmentApi, INavigationService navigationService) : base(navigationService)
        {
            _departmentApi = departmentApi;
        }
        ObservableCollection<DepartmentDTO> departments;

        public ObservableCollection<DepartmentDTO> Departments
        {
            get => departments;
            set
            {
                departments = value;
                RaisePropertyChanged(() => Departments);
            }
        }

        public ICommand ChooseDepartmentCommand =>
            new Command<DepartmentDTO>(department => DepartmentChosen(department));

        private void DepartmentChosen(DepartmentDTO department)
        {
            GlobalSettings.Instance.DepartmentId = (long)department.Id;
            NavigationService.NavigateToAsync<LoginViewModel>();
        }

        public override async Task InitializeAsync(object navigationData)
        {
            ResponseListDepartmentDTO result;

            try
            {
                result = await _departmentApi.V1DepartmentGetAsync();
            }
            catch (ApiException)
            {
                SendErrorMessage(null);
                return;
            }

            if (result.Success == false)
            {
                SendErrorMessage(result);
                return;
            }

            Departments = new ObservableCollection<DepartmentDTO>(result.Data);
        }

        private void SendErrorMessage(ResponseListDepartmentDTO result) {
            string friendlyErrorMessage;

            if(result == null) {
                friendlyErrorMessage = ErrorCodeHelper.ToFriendlyString(ResponseGirafUserDTO.ErrorKeyEnum.Error);
            } else {
                friendlyErrorMessage = result.ErrorKey.ToFriendlyString();
            }

            MessagingCenter.Send(this, MessageKeys.RequestFailed, friendlyErrorMessage);
        }

    }
}
