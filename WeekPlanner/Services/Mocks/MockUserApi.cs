using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace WeekPlanner.Services.Mocks
{
    public class MockUserApi : IUserApi
    {
        public Configuration Configuration { get; set; }
        public string GetBasePath()
        {
            throw new System.NotImplementedException();
        }

        public ExceptionFactory ExceptionFactory { get; set; }
        public ResponseImageDTO V1UserByIdIconGet(string id)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseImageDTO> V1UserByIdIconGetWithHttpInfo(string id)
        {
            throw new System.NotImplementedException();
        }

        public void V1UserByIdIconRawGet(string id)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<object> V1UserByIdIconRawGetWithHttpInfo(string id)
        {
            throw new System.NotImplementedException();
        }

        public ResponseGirafUserDTO V1UserByIdPatch(string id, string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseGirafUserDTO> V1UserByIdPatchWithHttpInfo(string id, string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseSettingDTO V1UserByIdSettingsGet(string id)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseSettingDTO> V1UserByIdSettingsGetWithHttpInfo(string id)
        {
            throw new System.NotImplementedException();
        }

        public ResponseSettingDTO V1UserByIdSettingsPatch(string id, SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseSettingDTO> V1UserByIdSettingsPatchWithHttpInfo(string id, SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseListUserNameDTO V1UserByUsernameCitizensGet(string username)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseListUserNameDTO> V1UserByUsernameCitizensGetWithHttpInfo(string username)
        {
            throw new System.NotImplementedException();
        }

        public ResponseDepartmentDTO V1UserByUsernameDepartmentDelete(string username)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1UserByUsernameDepartmentDeleteWithHttpInfo(string username)
        {
            throw new System.NotImplementedException();
        }

        public ResponseGirafUserDTO V1UserByUsernameGet(string username)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseGirafUserDTO> V1UserByUsernameGetWithHttpInfo(string username)
        {
            throw new System.NotImplementedException();
        }

        public ResponseListUserNameDTO V1UserByUsernameGuardiansGet(string username)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseListUserNameDTO> V1UserByUsernameGuardiansGetWithHttpInfo(string username)
        {
            throw new System.NotImplementedException();
        }

        public ResponseGirafUserDTO V1UserByUsernameResourcePost(string username, ResourceIdDTO resourceIdDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseGirafUserDTO> V1UserByUsernameResourcePostWithHttpInfo(string username, ResourceIdDTO resourceIdDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseGirafUserDTO V1UserDisplayNamePut(string displayName = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseGirafUserDTO> V1UserDisplayNamePutWithHttpInfo(string displayName = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseGirafUserDTO V1UserGet()
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseGirafUserDTO> V1UserGetWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public ResponseGirafUserDTO V1UserGuardianByGuardianIdCitizenByCitizenIdPost(string guardianId, string citizenId)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseGirafUserDTO> V1UserGuardianByGuardianIdCitizenByCitizenIdPostWithHttpInfo(string guardianId, string citizenId)
        {
            throw new System.NotImplementedException();
        }

        public Response V1UserIconDelete()
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<Response> V1UserIconDeleteWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public Response V1UserIconPut()
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<Response> V1UserIconPutWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public ResponseGirafUserDTO V1UserPatch(string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseGirafUserDTO> V1UserPatchWithHttpInfo(string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseGirafUserDTO V1UserResourceDelete(ResourceIdDTO resourceIdDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseGirafUserDTO> V1UserResourceDeleteWithHttpInfo(ResourceIdDTO resourceIdDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseSettingDTO V1UserSettingsGet()
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseSettingDTO> V1UserSettingsGetWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public ResponseSettingDTO V1UserSettingsPatch(SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseSettingDTO> V1UserSettingsPatchWithHttpInfo(SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseString V1UserUsernameGet()
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseString> V1UserUsernameGetWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseImageDTO> V1UserByIdIconGetAsync(string id)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseImageDTO>> V1UserByIdIconGetAsyncWithHttpInfo(string id)
        {
            throw new System.NotImplementedException();
        }

        public async Task V1UserByIdIconRawGetAsync(string id)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<object>> V1UserByIdIconRawGetAsyncWithHttpInfo(string id)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseGirafUserDTO> V1UserByIdPatchAsync(string id, string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseGirafUserDTO>> V1UserByIdPatchAsyncWithHttpInfo(string id, string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseSettingDTO> V1UserByIdSettingsGetAsync(string id)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseSettingDTO>> V1UserByIdSettingsGetAsyncWithHttpInfo(string id)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseSettingDTO> V1UserByIdSettingsPatchAsync(string id, SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseSettingDTO>> V1UserByIdSettingsPatchAsyncWithHttpInfo(string id, SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseListUserNameDTO> V1UserByUsernameCitizensGetAsync(string username)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseListUserNameDTO>> V1UserByUsernameCitizensGetAsyncWithHttpInfo(string username)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseDepartmentDTO> V1UserByUsernameDepartmentDeleteAsync(string username)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseDepartmentDTO>> V1UserByUsernameDepartmentDeleteAsyncWithHttpInfo(string username)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseGirafUserDTO> V1UserByUsernameGetAsync(string username)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseGirafUserDTO>> V1UserByUsernameGetAsyncWithHttpInfo(string username)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseListUserNameDTO> V1UserByUsernameGuardiansGetAsync(string username)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseListUserNameDTO>> V1UserByUsernameGuardiansGetAsyncWithHttpInfo(string username)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseGirafUserDTO> V1UserByUsernameResourcePostAsync(string username, ResourceIdDTO resourceIdDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseGirafUserDTO>> V1UserByUsernameResourcePostAsyncWithHttpInfo(string username, ResourceIdDTO resourceIdDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseGirafUserDTO> V1UserDisplayNamePutAsync(string displayName = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseGirafUserDTO>> V1UserDisplayNamePutAsyncWithHttpInfo(string displayName = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseGirafUserDTO> V1UserGetAsync()
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseGirafUserDTO>> V1UserGetAsyncWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseGirafUserDTO> V1UserGuardianByGuardianIdCitizenByCitizenIdPostAsync(string guardianId, string citizenId)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseGirafUserDTO>> V1UserGuardianByGuardianIdCitizenByCitizenIdPostAsyncWithHttpInfo(string guardianId, string citizenId)
        {
            throw new System.NotImplementedException();
        }

        public async Task<Response> V1UserIconDeleteAsync()
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<Response>> V1UserIconDeleteAsyncWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public async Task<Response> V1UserIconPutAsync()
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<Response>> V1UserIconPutAsyncWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseGirafUserDTO> V1UserPatchAsync(string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseGirafUserDTO>> V1UserPatchAsyncWithHttpInfo(string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseGirafUserDTO> V1UserResourceDeleteAsync(ResourceIdDTO resourceIdDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseGirafUserDTO>> V1UserResourceDeleteAsyncWithHttpInfo(ResourceIdDTO resourceIdDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseSettingDTO> V1UserSettingsGetAsync()
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseSettingDTO>> V1UserSettingsGetAsyncWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseSettingDTO> V1UserSettingsPatchAsync(SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseSettingDTO>> V1UserSettingsPatchAsyncWithHttpInfo(SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseString> V1UserUsernameGetAsync()
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseString>> V1UserUsernameGetAsyncWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public ResponseGirafUserDTO V1UserByIdPut(string id, string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseGirafUserDTO> V1UserByIdPutWithHttpInfo(string id, string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseSettingDTO V1UserByIdSettingsPut(string id, SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseSettingDTO> V1UserByIdSettingsPutWithHttpInfo(string id, SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseGirafUserDTO V1UserPut(string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseGirafUserDTO> V1UserPutWithHttpInfo(string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseSettingDTO V1UserSettingsPut(SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseSettingDTO> V1UserSettingsPutWithHttpInfo(SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseGirafUserDTO> V1UserByIdPutAsync(string id, string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseGirafUserDTO>> V1UserByIdPutAsyncWithHttpInfo(string id, string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseSettingDTO> V1UserByIdSettingsPutAsync(string id, SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseSettingDTO>> V1UserByIdSettingsPutAsyncWithHttpInfo(string id, SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseGirafUserDTO> V1UserPutAsync(string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseGirafUserDTO>> V1UserPutAsyncWithHttpInfo(string username = null, string screenName = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseSettingDTO> V1UserSettingsPutAsync(SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseSettingDTO>> V1UserSettingsPutAsyncWithHttpInfo(SettingDTO options = null)
        {
            throw new System.NotImplementedException();
        }
    }
}