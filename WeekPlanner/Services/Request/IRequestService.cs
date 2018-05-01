using System;
using System.Threading.Tasks;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.Services.Request
{
    public interface IRequestService
    {
        /// <summary>
        /// Sends a request, then sends and invokes the correct messages and functions based on the result.
        /// </summary>
        /// <param name="requestAsync">The request to send</param>
        /// <param name="onSuccessAsync">Invoked if the request succeeds</param>
        /// <param name="onExceptionAsync">If the request throws an ApiException, this is invoked after sending a message wtih exceptionErrorMessageKey</param>
        /// <param name="onRequestFailedAsync">If the request returns success = false, this is invoked after sending a message with requestFailedMessageKey</param>
        /// <param name="exceptionErrorMessageKey">The messagekey used on exceptions, default is RequestFailed</param>
        /// <param name="requestFailedMessageKey">The messagekey used on requestfailed, default is RequestFailed</param>
        /// <typeparam name="TR">The inner result type of the requestAsync</typeparam>
        /// <returns></returns>
        Task SendRequestAndThenAsync<TR>(Func<Task<TR>> requestAsync, Func<TR, Task> onSuccessAsync,
            Func<Task> onExceptionAsync = null,
            Func<Task> onRequestFailedAsync = null,
            string exceptionErrorMessageKey = MessageKeys.RequestFailed,
            string requestFailedMessageKey = MessageKeys.RequestFailed);
        
        /// <summary>
        /// Sends a request, then sends and invokes the correct messages and functions based on the result.
        /// </summary>
        /// <param name="requestAsync">The request to send</param>
        /// <param name="onSuccess">Invoked if the request succeeds</param>
        /// <param name="onExceptionAsync">If the request throws an ApiException, this is invoked after sending a message wtih exceptionErrorMessageKey</param>
        /// <param name="onRequestFailedAsync">If the request returns success = false, this is invoked after sending a message with requestFailedMessageKey</param>
        /// <param name="exceptionErrorMessageKey">The messagekey used on exceptions, default is RequestFailed</param>
        /// <param name="requestFailedMessageKey">The messagekey used on requestfailed, default is RequestFailed</param>
        /// <typeparam name="TR">The inner result type of the requestAsync</typeparam>
        /// <returns></returns>
        Task SendRequestAndThenAsync<TR>(Func<Task<TR>> requestAsync,
            Action<TR> onSuccess,
            Func<Task> onExceptionAsync = null,
            Func<Task> onRequestFailedAsync = null,
            string exceptionErrorMessageKey = MessageKeys.RequestFailed,
            string requestFailedMessageKey = MessageKeys.RequestFailed);
    }
}