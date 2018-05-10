using System;
using System.Threading.Tasks;
using WeekPlanner.Services.Settings;

namespace WeekPlanner.Services.Login
{
    public interface ILoginService
    {
        Task LoginAndThenAsync(UserType userType, string username, string password = "", Func<Task> onSuccess = null);
        Task LoginAsync(UserType userType, string username, string password = "");
    }
}