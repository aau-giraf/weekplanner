using System;
using System.Threading.Tasks;
using IO.Swagger.Model;

namespace WeekPlanner.Services.Networking
{
    public class MockNetworkingService : INetworkingService
    {
        public Task<ResponseGirafUserDTO> SendLoginRequest(string username, string password)
        {
            ResponseGirafUserDTO result;

            if (username == "Graatand" && password == "password")
            {
                result = new ResponseGirafUserDTO
                {
                    Success = true,
                    ErrorKey = ResponseGirafUserDTO.ErrorKeyEnum.NoError,
                    Data = new GirafUserDTO
                    {
                        Username = "Graatand",
                    }
                };
            }
            else
            {
                result = new ResponseGirafUserDTO
                {
                    Success = false,
                    ErrorKey = ResponseGirafUserDTO.ErrorKeyEnum.InvalidCredentials,
                };
            }
            return Task.FromResult(result);
        }
    }
}
