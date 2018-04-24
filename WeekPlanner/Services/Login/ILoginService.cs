using System;
using System.Threading.Tasks;
using WeekPlanner.Services.Settings;

namespace WeekPlanner.Services.Login
{
    public interface ILoginService
    {
        Task LoginAndThenAsync(Func<Task> onSuccess, UserType userType, string username, string password = "");
        Task LoginAsync(UserType userType, string username, string password = "");
    }
}