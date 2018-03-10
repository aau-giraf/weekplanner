using IO.Swagger.Model;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace WeekPlanner
{
    public interface IDataStore<T>
    {
        Task<bool> AddItemAsync(T item);
        Task<bool> UpdateItemAsync(T item);
        Task<bool> DeleteItemAsync(string id);
        Task<T> GetItemAsync(string id);
        Task<IEnumerable<T>> GetItemsAsync(bool forceRefresh = false);
        Task<ResponseGirafUserDTO> SendLoginRequest(string username, string password);
    }
}
