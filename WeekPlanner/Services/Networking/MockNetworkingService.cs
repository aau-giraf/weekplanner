using System.Collections.Generic;
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
                        GuardianOf = new List<GirafUserDTO>
                        {
                            new GirafUserDTO { Username = "Kurt"},
                            new GirafUserDTO { Username = "Søren"},
                            new GirafUserDTO { Username = "Elisabeth"},
                            new GirafUserDTO { Username = "Ulrik"},
                            new GirafUserDTO { Username = "Thomas"},
                            new GirafUserDTO { Username = "Elise"},
                            new GirafUserDTO { Username = "Maria"},
                        }
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
