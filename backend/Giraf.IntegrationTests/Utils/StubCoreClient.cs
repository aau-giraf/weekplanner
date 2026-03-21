using GirafAPI.Clients;

namespace Giraf.IntegrationTests.Utils;

/// <summary>
/// Stub CoreClient for integration tests.
/// Returns Valid for IDs 1-100, NotFound for anything else.
/// </summary>
public class StubCoreClient : ICoreClient
{
    private static CoreValidationResult Check(int id) =>
        id >= 1 && id <= 100 ? CoreValidationResult.Valid : CoreValidationResult.NotFound;

    public Task<CoreValidationResult> ValidateCitizenAsync(int id, string accessToken, CancellationToken ct = default) =>
        Task.FromResult(Check(id));

    public Task<CoreValidationResult> ValidateGradeAsync(int id, string accessToken, CancellationToken ct = default) =>
        Task.FromResult(Check(id));

    public Task<CoreValidationResult> ValidatePictogramAsync(int id, string accessToken, CancellationToken ct = default) =>
        Task.FromResult(Check(id));
}
