using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace WeekPlanner.Services.Mocks
{
    public class DepartmentMockService : IDepartmentApi
    {
        public DepartmentMockService()
        {
        }

        public Configuration Configuration { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public ExceptionFactory ExceptionFactory { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }

        public string GetBasePath()
        {
            throw new NotImplementedException();
        }

        public ResponseDepartmentDTO V1DepartmentByIdGet(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseDepartmentDTO> V1DepartmentByIdGetAsync(long? id)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseDepartmentDTO>> V1DepartmentByIdGetAsyncWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1DepartmentByIdGetWithHttpInfo(long? id)
        {
            throw new NotImplementedException();
        }

        public ResponseListDepartmentDTO V1DepartmentGet()
        {
            var departments = new List<DepartmentDTO> {
                new DepartmentDTO { Name = "Mockstuen", Id = 1 },
                new DepartmentDTO { Name = "Mocksted", Id = 2 },
                new DepartmentDTO { Name = "Mockpladsen", Id = 3 },
                new DepartmentDTO { Name = "Mockborg", Id = 4 },
                new DepartmentDTO { Name = "Mockvej", Id = 5 },
            };

            return new ResponseListDepartmentDTO
            {
                Success = true,
                Data = departments,
                ErrorKey = ResponseListDepartmentDTO.ErrorKeyEnum.NoError,
            };
        }

        public Task<ResponseListDepartmentDTO> V1DepartmentGetAsync()
        {
            var departments = new List<DepartmentDTO> {
                new DepartmentDTO { Name = "Mockstuen", Id = 1 },
                new DepartmentDTO { Name = "Mocksted", Id = 2 },
                new DepartmentDTO { Name = "Mockpladsen", Id = 3 },
                new DepartmentDTO { Name = "Mockborg", Id = 4 },
                new DepartmentDTO { Name = "Mockvej", Id = 5 },
            };

            var response = new ResponseListDepartmentDTO
            {
                Success = true,
                Data = departments,
                ErrorKey = ResponseListDepartmentDTO.ErrorKeyEnum.NoError,
            };

            return Task.FromResult(response);
        }

        public Task<ApiResponse<ResponseListDepartmentDTO>> V1DepartmentGetAsyncWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseListDepartmentDTO> V1DepartmentGetWithHttpInfo()
        {
            throw new NotImplementedException();
        }

        public ResponseDepartmentDTO V1DepartmentPost(DepartmentDTO dep = null)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseDepartmentDTO> V1DepartmentPostAsync(DepartmentDTO dep = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseDepartmentDTO>> V1DepartmentPostAsyncWithHttpInfo(DepartmentDTO dep = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1DepartmentPostWithHttpInfo(DepartmentDTO dep = null)
        {
            throw new NotImplementedException();
        }

        public ResponseDepartmentDTO V1DepartmentResourceByDepartmentIDPost(long? departmentID, ResourceIdDTO resourceDTO = null)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseDepartmentDTO> V1DepartmentResourceByDepartmentIDPostAsync(long? departmentID, ResourceIdDTO resourceDTO = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseDepartmentDTO>> V1DepartmentResourceByDepartmentIDPostAsyncWithHttpInfo(long? departmentID, ResourceIdDTO resourceDTO = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1DepartmentResourceByDepartmentIDPostWithHttpInfo(long? departmentID, ResourceIdDTO resourceDTO = null)
        {
            throw new NotImplementedException();
        }

        public ResponseDepartmentDTO V1DepartmentResourceDelete(ResourceIdDTO resourceDTO = null)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseDepartmentDTO> V1DepartmentResourceDeleteAsync(ResourceIdDTO resourceDTO = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseDepartmentDTO>> V1DepartmentResourceDeleteAsyncWithHttpInfo(ResourceIdDTO resourceDTO = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1DepartmentResourceDeleteWithHttpInfo(ResourceIdDTO resourceDTO = null)
        {
            throw new NotImplementedException();
        }

        public ResponseDepartmentDTO V1DepartmentUserByDepartmentIDDelete(long? departmentID, GirafUser usr = null)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseDepartmentDTO> V1DepartmentUserByDepartmentIDDeleteAsync(long? departmentID, GirafUser usr = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseDepartmentDTO>> V1DepartmentUserByDepartmentIDDeleteAsyncWithHttpInfo(long? departmentID, GirafUser usr = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1DepartmentUserByDepartmentIDDeleteWithHttpInfo(long? departmentID, GirafUser usr = null)
        {
            throw new NotImplementedException();
        }

        public ResponseDepartmentDTO V1DepartmentUserByDepartmentIDPost(long? departmentID, GirafUserDTO usr = null)
        {
            throw new NotImplementedException();
        }

        public Task<ResponseDepartmentDTO> V1DepartmentUserByDepartmentIDPostAsync(long? departmentID, GirafUserDTO usr = null)
        {
            throw new NotImplementedException();
        }

        public Task<ApiResponse<ResponseDepartmentDTO>> V1DepartmentUserByDepartmentIDPostAsyncWithHttpInfo(long? departmentID, GirafUserDTO usr = null)
        {
            throw new NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1DepartmentUserByDepartmentIDPostWithHttpInfo(long? departmentID, GirafUserDTO usr = null)
        {
            throw new NotImplementedException();
        }
    }
}
