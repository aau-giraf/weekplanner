using System.Net;
using System.Net.Http.Headers;

namespace GirafAPI.Clients;

public class GirafCoreClient : ICoreClient
{
    private readonly HttpClient _httpClient;

    public GirafCoreClient(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public async Task<CoreValidationResult> ValidateCitizenAsync(int id, string accessToken, CancellationToken ct = default)
    {
        return await ExistsAsync($"/api/v1/citizens/{id}", accessToken, ct);
    }

    public async Task<CoreValidationResult> ValidateGradeAsync(int id, string accessToken, CancellationToken ct = default)
    {
        return await ExistsAsync($"/api/v1/grades/{id}", accessToken, ct);
    }

    public async Task<CoreValidationResult> ValidatePictogramAsync(int id, string accessToken, CancellationToken ct = default)
    {
        return await ExistsAsync($"/api/v1/pictograms/{id}", accessToken, ct);
    }

    private async Task<CoreValidationResult> ExistsAsync(string path, string accessToken, CancellationToken ct)
    {
        using var request = new HttpRequestMessage(HttpMethod.Get, path);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

        var response = await _httpClient.SendAsync(request, ct);
        return response.StatusCode switch
        {
            HttpStatusCode.OK => CoreValidationResult.Valid,
            HttpStatusCode.NotFound => CoreValidationResult.NotFound,
            HttpStatusCode.Forbidden => CoreValidationResult.Forbidden,
            _ => throw new HttpRequestException(
                $"Core API returned unexpected status {(int)response.StatusCode} for {path}")
        };
    }
}
