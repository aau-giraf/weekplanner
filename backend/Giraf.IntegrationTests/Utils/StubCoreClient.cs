using GirafAPI.Clients;

namespace Giraf.IntegrationTests.Utils;

/// <summary>
/// Stub CoreClient for integration tests.
/// IDs 1-100: Valid, IDs 101-200: Forbidden, everything else: NotFound.
/// </summary>
public class StubCoreClient : ICoreClient
{
    private static CoreValidationResult Check(int id) =>
        id switch
        {
            >= 1 and <= 100 => CoreValidationResult.Valid,
            >= 101 and <= 200 => CoreValidationResult.Forbidden,
            _ => CoreValidationResult.NotFound
        };

    public Task<CoreValidationResult> ValidateCitizenAsync(int id, string accessToken, CancellationToken ct = default) =>
        Task.FromResult(Check(id));

    public Task<CoreValidationResult> ValidateGradeAsync(int id, string accessToken, CancellationToken ct = default) =>
        Task.FromResult(Check(id));

    public Task<CoreValidationResult> ValidatePictogramAsync(int id, string accessToken, CancellationToken ct = default) =>
        Task.FromResult(Check(id));
}
