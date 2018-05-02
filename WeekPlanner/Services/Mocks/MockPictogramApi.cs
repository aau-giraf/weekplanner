using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using System;
using System.Threading.Tasks;

namespace WeekPlanner.Services.Mocks
{
    public class MockPictogramApi : IPictogramApi
    {
        public Configuration Configuration { get; set; }
        public string GetBasePath()
        {
            throw new NotImplementedException();
        }

        public ExceptionFactory ExceptionFactory { get; set; }
        public Response V1PictogramByIdDelete(int? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<Response> V1PictogramByIdDeleteWithHttpInfo(int? id)
        {
            throw new NotImplementedException();
        }

        public ResponsePictogramDTO V1PictogramByIdGet(long? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponsePictogramDTO> V1PictogramByIdGetWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ResponseByte V1PictogramByIdImageGet(long? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseByte> V1PictogramByIdImageGetWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ResponsePictogramDTO V1PictogramByIdImagePut(long? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponsePictogramDTO> V1PictogramByIdImagePutWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public void V1PictogramByIdImageRawGet(long? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<object> V1PictogramByIdImageRawGetWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ResponsePictogramDTO V1PictogramByIdPut(long? id, PictogramDTO pictogram = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponsePictogramDTO> V1PictogramByIdPutWithHttpInfo(long? id, PictogramDTO pictogram = null)
        {
            throw new NotImplementedException();
        }

        public ResponseListPictogramDTO V1PictogramGet(int? page, int? pageSize, string query = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseListPictogramDTO> V1PictogramGetWithHttpInfo(int? page, int? pageSize, string query = null)
        {
            throw new NotImplementedException();
        }

        public ResponsePictogramDTO V1PictogramPost(PictogramDTO pictogram = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponsePictogramDTO> V1PictogramPostWithHttpInfo(PictogramDTO pictogram = null)
        {
            throw new NotImplementedException();
        }

        public Task<Response> V1PictogramByIdDeleteAsync(int? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<Response>> V1PictogramByIdDeleteAsyncWithHttpInfo(int? id)
        {
            throw new NotImplementedException();
        }

        public Task<ResponsePictogramDTO> V1PictogramByIdGetAsync(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponsePictogramDTO>> V1PictogramByIdGetAsyncWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseByte> V1PictogramByIdImageGetAsync(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseByte>> V1PictogramByIdImageGetAsyncWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ResponsePictogramDTO> V1PictogramByIdImagePutAsync(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponsePictogramDTO>> V1PictogramByIdImagePutAsyncWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public Task V1PictogramByIdImageRawGetAsync(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<object>> V1PictogramByIdImageRawGetAsyncWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ResponsePictogramDTO> V1PictogramByIdPutAsync(long? id, PictogramDTO pictogram = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponsePictogramDTO>> V1PictogramByIdPutAsyncWithHttpInfo(long? id, PictogramDTO pictogram = null)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseListPictogramDTO> V1PictogramGetAsync(int? page, int? pageSize, string query = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseListPictogramDTO>> V1PictogramGetAsyncWithHttpInfo(int? page, int? pageSize, string query = null)
        {
            throw new NotImplementedException();
        }

        public Task<ResponsePictogramDTO> V1PictogramPostAsync(PictogramDTO pictogram = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponsePictogramDTO>> V1PictogramPostAsyncWithHttpInfo(PictogramDTO pictogram = null)
        {
            throw new NotImplementedException();
        }
    }
}
