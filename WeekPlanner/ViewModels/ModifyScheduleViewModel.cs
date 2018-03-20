using System;
using System.IO;
using System.Net;
using System.Text;
using IO.Swagger.Model;
using IO.Swagger.Client;
using IO.Swagger.Api;
using System.Threading.Tasks;
using WeekPlanner.ViewModels.Base;
using WeekPlanner.Helpers;
using Xamarin.Forms;
using WeekPlanner.Services.Navigation;
using System.Windows.Input;

namespace WeekPlanner.ViewModels
{
    public class ModifyScheduleViewModel : ViewModelBase
    {
        private readonly IWeekApi _weekApi;

        public ModifyScheduleViewModel(INavigationService navigationService, IWeekApi weekApi) : base(navigationService)
        {
            _weekApi = weekApi;   
        }

        public WeekDTO Schedule;

        public async void SaveSchedule()
        {
            ResponseWeekDTO result;

            if (Schedule.Id is null)
            {
                try
                {
                    // Save new schedule
                    result = await _weekApi.V1WeekPostAsync(Schedule);
                }
                catch (ApiException)
                {
                    // TODO make a "ServerDownError"
                    var friendlyErrorMessage = ErrorCodeHelper.ToFriendlyString(result.ErrorKey);
                    MessagingCenter.Send(this, MessageKeys.ScheduleSaveFailed, friendlyErrorMessage);
                    return;   
                }
            }
            else
            {
                try
                {
                    // update an existing schedule
                    result = await _weekApi.V1WeekByIdPutAsync (2, Schedule);
                }
                catch (ApiException)
                {
                    // TODO make a "ServerDownError"
                    var friendlyErrorMessage = ErrorCodeHelper.ToFriendlyString(ResponseWeekDTO.ErrorKeyEnum.Error);
                    MessagingCenter.Send(this, MessageKeys.ScheduleUpdateFailed, friendlyErrorMessage);
                    return;
                }
            }

        }

		public async override Task InitializeAsync(object navigationData)
		{
            if(navigationData is WeekDTO week)
            {
                // Modifying a schedule
                Schedule = week;
            }
            else
            {
                // Create new schedule
                Schedule = new WeekDTO();
            }
		}


	}
}
