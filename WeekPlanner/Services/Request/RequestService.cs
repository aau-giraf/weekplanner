using System;
using System.Threading.Tasks;
using IO.Swagger.Client;
using IO.Swagger.Model;
using WeekPlanner.Helpers;
using WeekPlanner.ViewModels.Base;
using Xamarin.Forms;

namespace WeekPlanner.Services.Request
{
    public class RequestService : IRequestService
    {
         /// <summary>
        /// Sends a request, then sends and invokes the correct messages and functions based on the result.
        /// </summary>
        /// <param name="sender">Give 'this' as input. Used for the message.</param>
        /// <param name="requestAsync">The request to send</param>
        /// <param name="onSuccessAsync">Invoked if the request succeeds</param>
        /// <param name="onExceptionAsync">Optional, invoked if the request throws an ApiException</param>
        /// <param name="onRequestFailedAsync">Optional, invoked if the request returns success = false</param>
        /// <param name="exceptionErrorMessageKey">The messagekey used on exceptions, default is RequestFailed</param>
        /// <param name="requestFailedMessageKey">The messagekey used on requestfailed, default is RequestFailed</param>
        /// <typeparam name="TS">Type of the sender</typeparam>
        /// <typeparam name="TR">The inner result type of the requestAsync</typeparam>
        /// <returns></returns>
        public async Task SendRequestAndThenAsync<TS, TR>(TS sender, Func<Task<TR>> requestAsync, Func<TR, Task> onSuccessAsync,
            Func<Task> onExceptionAsync = null,
            Func<Task> onRequestFailedAsync = null,
            string exceptionErrorMessageKey = MessageKeys.RequestFailed,
            string requestFailedMessageKey = MessageKeys.RequestFailed) where TS : class
        {
            // TODO: Check for internet connection first.
            dynamic result;
            try
            {
                result = await requestAsync.Invoke();
            }
            catch (ApiException)
            {
                var friendlyErrorMessage = ErrorCodeHelper.ToFriendlyString(ResponseString.ErrorKeyEnum.Error);
                MessagingCenter.Send(sender, exceptionErrorMessageKey, friendlyErrorMessage);

                if (onExceptionAsync != null)
                {
                    await onExceptionAsync.Invoke();
                }
                return;
            }

            if (result.Success == true)
            {
                await onSuccessAsync.Invoke(result);
            }
            else
            {
                var friendlyErrorMessage = result.ErrorKey.ToFriendlyString();
                MessagingCenter.Send(sender, requestFailedMessageKey, friendlyErrorMessage);

                if (onRequestFailedAsync != null)
                {
                    await onRequestFailedAsync.Invoke();
                }
            }
        }

        /// <summary>
        /// Sends a request, then sends and invokes the correct messages and functions based on the result.
        /// </summary>
        /// <param name="sender">Give 'this' as input. Used for the message.</param>
        /// <param name="requestAsync">The request to send</param>
        /// <param name="onSuccess">Invoked if the request succeeds</param>
        /// <param name="onExceptionAsync">Optional, invoked if the request throws an ApiException</param>
        /// <param name="onRequestFailedAsync">Optional, invoked if the request returns success = false</param>
        /// <param name="exceptionErrorMessageKey">The messagekey used on exceptions, default is RequestFailed</param>
        /// <param name="requestFailedMessageKey">The messagekey used on requestfailed, default is RequestFailed</param>
        /// <typeparam name="TS">Type of the sender</typeparam>
        /// <typeparam name="TR">The inner result type of the requestAsync</typeparam>
        /// <returns></returns>
        public async Task SendRequestAndThenAsync<TS, TR>(TS sender, Func<Task<TR>> requestAsync,
            Action<TR> onSuccess,
            Func<Task> onExceptionAsync = null,
            Func<Task> onRequestFailedAsync = null,
            string exceptionErrorMessageKey = MessageKeys.RequestFailed,
            string requestFailedMessageKey = MessageKeys.RequestFailed) where TS : class
        {
            async Task OnSuccessAsync(TR result)
            {
                onSuccess.Invoke(result);
            }
               
            await SendRequestAndThenAsync(sender, requestAsync, OnSuccessAsync,
                onExceptionAsync, onRequestFailedAsync, exceptionErrorMessageKey, requestFailedMessageKey);
        }
    }
}