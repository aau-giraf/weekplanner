# Weekplanner Backend — Architecture

High-level reference for developers joining the project.

## Layered Architecture

The backend follows a **hexagonal (ports-and-adapters)** pattern. Each layer has one job and depends only on the layer below it:

```
HTTP Request
     │
     ▼
┌──────────────────────┐
│  Endpoints           │  Thin HTTP shell — route binding, token extraction,
│  (ActivityEndpoints)  │  mapping ServiceResult → HTTP status codes.
└──────────┬───────────┘  No business logic lives here.
           │
           ▼
┌──────────────────────┐
│  Services            │  All business logic — validation, DB queries,
│  (ActivityService)    │  external API calls via ports.
└──────────┬───────────┘  Returns ServiceResult<T>, never IResult.
           │
           ▼
┌──────────────────────┐
│  Ports & Adapters    │  Interfaces (ICoreClient) with production
│  (ICoreClient →      │  adapters (GirafCoreClient) and test stubs
│   GirafCoreClient)   │  (StubCoreClient).
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  Data                │  EF Core DbContext + entity models.
│  (GirafDbContext)     │  PostgreSQL in production, SQLite in tests.
└──────────────────────┘
```

## Key Directory Layout

```
GirafAPI/
├── Program.cs            # Host builder, middleware pipeline
├── Endpoints/            # Minimal API route handlers (HTTP concern only)
├── Services/             # Business logic, interfaces, ServiceResult types
├── Entities/             # EF Core entities + DTOs
├── Mapping/              # Entity ↔ DTO mapping extensions
├── Clients/              # ICoreClient port + GirafCoreClient adapter
├── Data/                 # GirafDbContext
├── Configuration/        # JwtSettings POCO
└── Extensions/           # DI registration extension methods
```

## ServiceResult Pattern

Services return `ServiceResult<T>` (or `ServiceResult` for void operations) instead of throwing exceptions or returning HTTP types. This keeps business logic independent of ASP.NET:

```csharp
// In the service:
return ServiceResult<ActivityDTO>.Fail(
    new ServiceError(ServiceErrorKind.NotFound, "Activity not found."));

// In the endpoint — one shared helper maps results to HTTP:
return ToHttpResult(result);
```

`ServiceErrorKind` values: `NotFound`, `Validation`, `Unauthorized`, `Conflict`, `Internal`.

## Authentication & Authorization

- **Authentication**: JWT Bearer tokens issued by giraf-core. The weekplanner backend validates the signature using a shared `JWT_SECRET` and extracts the `user_id` claim.
- **Authorization**: There are no custom authorization policies in this backend. Endpoints call `.RequireAuthorization()` (which simply requires a valid JWT). Access control for citizen/grade ownership is **delegated to giraf-core** — the service layer forwards the user's token via `ICoreClient.ValidateCitizenAsync()` / `ValidateGradeAsync()`, and giraf-core checks whether the user belongs to the correct organization.

This keeps the weekplanner backend simple: it trusts giraf-core as the authority for organizational access control.

## Request Flow Example

**POST /weekplan/to-citizen/42** (create activity for citizen):

1. **Endpoint** extracts Bearer token from `Authorization` header
2. **Endpoint** calls `service.CreateActivityForCitizenAsync(42, dto, token)`
3. **Service** validates date/time fields → returns `Validation` error if bad
4. **Service** calls `ICoreClient.ValidateCitizenAsync(42, token)` → returns `NotFound` if citizen doesn't exist in giraf-core
5. **Service** maps DTO → Entity, saves to DB, returns `Success(activityDto)`
6. **Endpoint** maps `Success` → `Results.Created(...)`

## Ecosystem Context

```
weekplanner frontend (Flutter)
       │
       ├──→ weekplanner backend (this project)  — Activity CRUD only
       │         ├── GirafDbContext (PostgreSQL :5433)
       │         └── GirafCoreClient ──→ giraf-core API
       │
       └──→ giraf-core API (:8000)               — Users, orgs, citizens,
                 └── PostgreSQL (:5432)              grades, pictograms, JWT
```

**If it's shared across apps, it belongs in giraf-core.** The weekplanner backend manages only `Activity` entities. It validates citizen/grade/pictogram IDs against giraf-core at write time.

## Testing

- **Integration tests** (`Giraf.IntegrationTests/`) hit real HTTP endpoints via `WebApplicationFactory`. SQLite replaces PostgreSQL; `StubCoreClient` replaces the HTTP client to giraf-core.
- **No unit tests yet** — the service layer can now be unit-tested by mocking `GirafDbContext` and `ICoreClient` directly, without spinning up an HTTP host.

## Adding a New Endpoint

1. Add the method signature to `IActivityService`
2. Implement the logic in `ActivityService`, returning `ServiceResult<T>`
3. Add a thin route handler in `ActivityEndpoints` that calls the service and maps the result via `ToHttpResult()`
4. Write an integration test in `ActivityEndpointTests.cs`
