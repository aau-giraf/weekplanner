using System;
using System.IO;
using System.Net;
using System.Text;
using IO.Swagger.Model;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Client;
using WeekPlanner.Helpers;
using WeekPlanner.Services.Login;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;
using WeekPlanner.Services.Navigation;
using WeekPlanner.Services.Settings;

namespace WeekPlanner.ViewModels
{
    public class WeekPlannerViewModel : ViewModelBase
    {
        private GirafUserDTO _citizen;
        private WeekDTO _weekDto;
        
        private readonly IWeekApi _weekApi;
        private readonly ILoginService _loginService;
        
        public WeekDTO WeekDTO
        {
            get => _weekDto;
            set
            {
                _weekDto = value;
                RaisePropertyChanged(() => WeekDTO);
            }
        }
        public WeekPlannerViewModel(INavigationService navigationService, IWeekApi weekApi,
            ILoginService loginService) : base(navigationService)
        {
            _weekApi = weekApi;
            _loginService = loginService;
        }

        public ImageSource PictogramSource
        {
            get
            {
                string subset =
                    "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";
                byte[] byteArray = Convert.FromBase64String(subset);
                var stream = new MemoryStream(byteArray);
                return ImageSource.FromStream(() => stream);
            }
        }

        public GirafUserDTO Citizen
        {
            get => _citizen;
            set
            {
                _citizen = value;
                RaisePropertyChanged(() => Citizen);
            }
        }
        
        // TODO: Cleanup method and rename
        private async Task GetWeekPlanForCitizenAsync()
        {
            ResponseWeekDTO result;
            try
            {
                // TODO: Find the correct id to retrieve
                result = await _weekApi.V1WeekByIdGetAsync(1);
            }
            catch (ApiException)
            {
                var friendlyErrorMessage = ErrorCodeHelper.ToFriendlyString(ResponseWeekDTO.ErrorKeyEnum.Error);
                MessagingCenter.Send(this, MessageKeys.ServerError, friendlyErrorMessage);
                
                await NavigationService.PopAsync();
                return;
            }

            if (result.Success == true)
            {
                WeekDTO = result.Data;
            }
            else
            {
                MessagingCenter.Send(this, MessageKeys.RetrieveWeekPlanFailed, result.ErrorKey.ToFriendlyString());

                await NavigationService.PopAsync();
                return;
            }
        }

        public override async Task InitializeAsync(object navigationData)
        {
            if (navigationData is UserNameDTO userNameDTO)
            {
                await _loginService.LoginAndThenAsync(() => GetWeekPlanForCitizenAsync(), UserType.Citizen,
                    userNameDTO.UserName);
            }
            else
            {
                throw new ArgumentException("Must be of type WeekDTO", nameof(navigationData));
            }
        }
    }
}
