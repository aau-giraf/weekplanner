using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using IO.Swagger.Api;
using IO.Swagger.Client;
using IO.Swagger.Model;

namespace WeekPlanner.Services.Mocks
{
    public class MockDepartmentApi : IDepartmentApi
    {
        public Configuration Configuration { get; set; }
        public string GetBasePath()
        {
            throw new System.NotImplementedException();
        }

        public ExceptionFactory ExceptionFactory { get; set; }
        public ResponseListUserNameDTO V1DepartmentByIdCitizensGet(long? id)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseListUserNameDTO> V1DepartmentByIdCitizensGetWithHttpInfo(long? id)
        {
            throw new System.NotImplementedException();
        }

        public ResponseDepartmentDTO V1DepartmentByIdGet(long? id)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1DepartmentByIdGetWithHttpInfo(long? id)
        {
            throw new System.NotImplementedException();
        }

        public ResponseListDepartmentNameDTO V1DepartmentGet()
        {
            var departments = new List<DepartmentNameDTO> {
                new DepartmentNameDTO { Name = "Birken", Id = 1 },
                new DepartmentNameDTO { Name = "Egebakken", Id = 2 },
                new DepartmentNameDTO { Name = "Enterne", Id = 3 },
                new DepartmentNameDTO { Name = "Fagcenteret", Id = 4 },
            };

            return new ResponseListDepartmentNameDTO
            {
                Success = true,
                Data = departments,
                ErrorKey = ResponseListDepartmentNameDTO.ErrorKeyEnum.NoError,
            };
        }

        public ApiResponse<ResponseListDepartmentNameDTO> V1DepartmentGetWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public ResponseDepartmentDTO V1DepartmentPost(DepartmentDTO depDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1DepartmentPostWithHttpInfo(DepartmentDTO depDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseDepartmentDTO V1DepartmentResourceByDepartmentIDPost(long? departmentID, ResourceIdDTO resourceDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1DepartmentResourceByDepartmentIDPostWithHttpInfo(long? departmentID, ResourceIdDTO resourceDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseDepartmentDTO V1DepartmentResourceDelete(ResourceIdDTO resourceDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1DepartmentResourceDeleteWithHttpInfo(ResourceIdDTO resourceDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseDepartmentDTO V1DepartmentUserByDepartmentIDDelete(long? departmentID, GirafUserDTO usr = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1DepartmentUserByDepartmentIDDeleteWithHttpInfo(long? departmentID, GirafUserDTO usr = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseDepartmentDTO V1DepartmentUserByDepartmentIDPost(long? departmentID, GirafUserDTO usr = null)
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseDepartmentDTO> V1DepartmentUserByDepartmentIDPostWithHttpInfo(long? departmentID, GirafUserDTO usr = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseListUserNameDTO> V1DepartmentByIdCitizensGetAsync(long? id)
        {
            string[] usernames = {"Kurt", "Søren", "Elisabeth", "Ulrik", "Thomas", "Elise", "Maria"};
            return new ResponseListUserNameDTO
            {
                Data = usernames.Select(x => new UserNameDTO(x)).ToList(),
                Success = true,
                ErrorKey = ResponseListUserNameDTO.ErrorKeyEnum.NoError
            };
        }

        public async Task<ApiResponse<ResponseListUserNameDTO>> V1DepartmentByIdCitizensGetAsyncWithHttpInfo(long? id)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseDepartmentDTO> V1DepartmentByIdGetAsync(long? id)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseDepartmentDTO>> V1DepartmentByIdGetAsyncWithHttpInfo(long? id)
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseListDepartmentNameDTO> V1DepartmentGetAsync()
        {
            var departments = new List<DepartmentNameDTO> {
                new DepartmentNameDTO { Name = "Birken", Id = 1 },
                new DepartmentNameDTO { Name = "Egebakken", Id = 2 },
                new DepartmentNameDTO { Name = "Enterne", Id = 3 },
                new DepartmentNameDTO { Name = "Fagcenteret", Id = 4 },
            };

            var response = new ResponseListDepartmentNameDTO
            {
                Success = true,
                Data = departments,
                ErrorKey = ResponseListDepartmentNameDTO.ErrorKeyEnum.NoError,
            };

            return Task.FromResult(response);
        }

        public async Task<ApiResponse<ResponseListDepartmentNameDTO>> V1DepartmentGetAsyncWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseDepartmentDTO> V1DepartmentPostAsync(DepartmentDTO depDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseDepartmentDTO>> V1DepartmentPostAsyncWithHttpInfo(DepartmentDTO depDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseDepartmentDTO> V1DepartmentResourceByDepartmentIDPostAsync(long? departmentID, ResourceIdDTO resourceDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseDepartmentDTO>> V1DepartmentResourceByDepartmentIDPostAsyncWithHttpInfo(long? departmentID, ResourceIdDTO resourceDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseDepartmentDTO> V1DepartmentResourceDeleteAsync(ResourceIdDTO resourceDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseDepartmentDTO>> V1DepartmentResourceDeleteAsyncWithHttpInfo(ResourceIdDTO resourceDTO = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseDepartmentDTO> V1DepartmentUserByDepartmentIDDeleteAsync(long? departmentID, GirafUserDTO usr = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseDepartmentDTO>> V1DepartmentUserByDepartmentIDDeleteAsyncWithHttpInfo(long? departmentID, GirafUserDTO usr = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ResponseDepartmentDTO> V1DepartmentUserByDepartmentIDPostAsync(long? departmentID, GirafUserDTO usr = null)
        {
            throw new System.NotImplementedException();
        }

        public async Task<ApiResponse<ResponseDepartmentDTO>> V1DepartmentUserByDepartmentIDPostAsyncWithHttpInfo(long? departmentID, GirafUserDTO usr = null)
        {
            throw new System.NotImplementedException();
        }

        public ResponseListDepartmentNameDTO V1DepartmentNamesGet()
        {
            throw new System.NotImplementedException();
        }

        public ApiResponse<ResponseListDepartmentNameDTO> V1DepartmentNamesGetWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }

        public Task<ResponseListDepartmentNameDTO> V1DepartmentNamesGetAsync()
        {
            throw new System.NotImplementedException();
        }

        public Task<ApiResponse<ResponseListDepartmentNameDTO>> V1DepartmentNamesGetAsyncWithHttpInfo()
        {
            throw new System.NotImplementedException();
        }
    }
}