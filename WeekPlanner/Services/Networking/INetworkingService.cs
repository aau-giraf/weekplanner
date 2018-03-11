using System;
using IO.Swagger.Model;
using System.Threading.Tasks;

namespace WeekPlanner.Services.Networking
{
    public interface INetworkingService
    {
        Task<ResponseGirafUserDTO> SendLoginRequest(string username, string password);
    }
}
