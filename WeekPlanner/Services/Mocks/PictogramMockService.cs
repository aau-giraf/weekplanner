using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace WeekPlanner.Services.Mocks
{
    public class PictogramMockService : IPictogramApi
    {
        public Configuration Configuration { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public ExceptionFactory ExceptionFactory { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }

        public string GetBasePath()
        {
            throw new NotImplementedException();
        }

        public Response V1PictogramByIdDelete(int? id)
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

        public ApiResponse<Response> V1PictogramByIdDeleteWithHttpInfo(int? id)
        {
            throw new NotImplementedException();
        }

        public ResponsePictogramDTO V1PictogramByIdGet(long? id)
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

        public ApiResponse<ResponsePictogramDTO> V1PictogramByIdGetWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ResponsePictogramDTO V1PictogramByIdPut(long? id, PictogramDTO pictogram = null)
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

        public ApiResponse<ResponsePictogramDTO> V1PictogramByIdPutWithHttpInfo(long? id, PictogramDTO pictogram = null)
        {
            throw new NotImplementedException();
        }

        public ResponseListPictogramDTO V1PictogramGet()
        {
            throw new NotImplementedException();
        }

        public Task<ResponseListPictogramDTO> V1PictogramGetAsync()
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseListPictogramDTO>> V1PictogramGetAsyncWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseListPictogramDTO> V1PictogramGetWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public ResponseByte V1PictogramImageByIdGet(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseByte> V1PictogramImageByIdGetAsync(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseByte>> V1PictogramImageByIdGetAsyncWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseByte> V1PictogramImageByIdGetWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ResponsePictogramDTO V1PictogramImageByIdPost(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ResponsePictogramDTO> V1PictogramImageByIdPostAsync(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponsePictogramDTO>> V1PictogramImageByIdPostAsyncWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponsePictogramDTO> V1PictogramImageByIdPostWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ResponsePictogramDTO V1PictogramImageByIdPut(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ResponsePictogramDTO> V1PictogramImageByIdPutAsync(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponsePictogramDTO>> V1PictogramImageByIdPutAsyncWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponsePictogramDTO> V1PictogramImageByIdPutWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ResponsePictogramDTO V1PictogramPost(PictogramDTO pictogram = null)
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

        public ApiResponse<ResponsePictogramDTO> V1PictogramPostWithHttpInfo(PictogramDTO pictogram = null)
        {
            throw new NotImplementedException();
        }
    }
}
