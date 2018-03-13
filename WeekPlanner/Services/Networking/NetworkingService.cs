using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using IO.Swagger.Model;
using Newtonsoft.Json;

namespace WeekPlanner.Services.Networking
{
    public class NetworkingService : INetworkingService
    {
        private readonly HttpClient _client;
        
        public NetworkingService()
        {
            _client = new HttpClient();
        }
        
        public async Task<ResponseGirafUserDTO> SendLoginRequest(string username, string password)
        {
            //TODO handle user being offline
            var serializedItem = JsonConvert.SerializeObject(new { Username = username, Password = password });
            var response = await _client.PostAsync(GlobalSettings.Instance.LoginEndpoint, new StringContent(serializedItem, Encoding.UTF8, "application/json"));
            // TODO handle HttpRequestException, happens when the server is down
            var json = await response.Content.ReadAsStringAsync();
            var responseGirafUserDTO = JsonConvert.DeserializeObject<ResponseGirafUserDTO>(json);
            return responseGirafUserDTO;
        }
    }
}
