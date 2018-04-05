using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using WeekPlanner.Helpers;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Settings;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.ViewModels
{
    public class ChooseDepartmentViewModel : ViewModelBase
    {
        private readonly IDepartmentApi _departmentApi;
        private readonly ISettingsService _settingsService;

        private ObservableCollection<DepartmentDTO> _departments;

        public ChooseDepartmentViewModel(IDepartmentApi departmentApi, 
                                         INavigationService navigationService, 
                                         ISettingsService settingsService) 
                                         : base(navigationService)
        {
            _departmentApi = departmentApi;
            _settingsService = settingsService;
        }

        public ICommand ChooseDepartmentCommand =>
            new Command<DepartmentDTO>(SetDepartmentIdAndNavigateToLogin);

        public ObservableCollection<DepartmentDTO> Departments
        {
            get => _departments;
            set
            {
                _departments = value;
                RaisePropertyChanged(() => Departments);
            }
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
                SendErrorMessage();
                return;
            }

            if (result.Success == false)
            {
                SendErrorMessage(result);
                return;
            }

            Departments = new ObservableCollection<DepartmentDTO>(result.Data);
        }

        private void SetDepartmentIdAndNavigateToLogin(DepartmentDTO department)
        {
            if (department != null) {
                _settingsService.Department = department;
            }
            NavigationService.NavigateToAsync<LoginViewModel>();
        }

        private void SendErrorMessage(ResponseListDepartmentDTO result = null)
        {
            string friendlyErrorMessage;

            if (result == null )
            {
                friendlyErrorMessage = ErrorCodeHelper.ToFriendlyString(ResponseGirafUserDTO.ErrorKeyEnum.Error);
            }
            else
            {
                friendlyErrorMessage = result.ErrorKey.ToFriendlyString();
            }

            MessagingCenter.Send(this, MessageKeys.RequestFailed, friendlyErrorMessage);
        }
    }
}
