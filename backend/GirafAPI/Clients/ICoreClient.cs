namespace GirafAPI.Clients;

public enum CoreValidationResult { Valid, NotFound, Forbidden }

public interface ICoreClient
{
    Task<CoreValidationResult> ValidateCitizenAsync(int id, string accessToken, CancellationToken ct = default);
    Task<CoreValidationResult> ValidateGradeAsync(int id, string accessToken, CancellationToken ct = default);
    Task<CoreValidationResult> ValidatePictogramAsync(int id, string accessToken, CancellationToken ct = default);
}
