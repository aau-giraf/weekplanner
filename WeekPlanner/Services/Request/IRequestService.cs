using System;
using System.Threading.Tasks;
using WeekPlanner.ViewModels.Base;

namespace WeekPlanner.Services.Request
{
    public interface IRequestService
    {
        Task SendRequestAndThenAsync<TS, TR>(TS sender, Func<Task<TR>> requestAsync, Func<TR, Task> onSuccessAsync,
            Func<Task> onExceptionAsync = null,
            Func<Task> onRequestFailedAsync = null,
            string exceptionErrorMessageKey = MessageKeys.RequestFailed,
            string requestFailedMessageKey = MessageKeys.RequestFailed) where TS : class;

        Task SendRequestAndThenAsync<TS, TR>(TS sender, Func<Task<TR>> requestAsync,
            Action<TR> onSuccess,
            Func<Task> onExceptionAsync = null,
            Func<Task> onRequestFailedAsync = null,
            string exceptionErrorMessageKey = MessageKeys.RequestFailed,
            string requestFailedMessageKey = MessageKeys.RequestFailed) where TS : class;
    }
}