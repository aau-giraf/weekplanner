# Testing Environment Setup Guide

This guide explains how the testing environment is set up for the Giraf Weekplanner API.

## Overview

Integration tests use:
- **`WebApplicationFactory<Program>`** to create a test server (no Docker/Postgres needed)
- **SQLite file-per-test** databases for full isolation
- **Seeders** to populate each test's database with the exact scenario it needs
- **Test JWT tokens** to authenticate as different user roles

Tests run without any external services — everything is self-contained.

## GirafWebApplicationFactory

The factory creates a test server with:
1. Environment set to `"Testing"` (skips auto-migration/seeding in `Program.cs`)
2. SQLite database with a unique filename per test (`GirafTestDb_{Guid}.db`)
3. JWT authentication configured with test credentials
4. Authorization policies re-registered for the test container
5. Optional `StubCoreClient` injection (pass `stubCoreClient: true`)
6. Automatic cleanup of DB files on dispose

```csharp
// Typical test setup pattern:
var factory = new GirafWebApplicationFactory();
var seeder = new BaseCaseDb();
var scope = factory.Services.CreateScope();
factory.SeedDb(scope, seeder);
var client = factory.CreateClient();
client.AttachClaimsToken(role: "member");
```

## DbSeeder System

`DbSeeder` is an abstract base class providing reusable seeding methods:

| Method | What it seeds |
|--------|--------------|
| `SeedCitizenActivity(dbContext, citizenId, pictogramId?)` | Creates an activity for a citizen |
| `SeedGradeActivity(dbContext, gradeId, pictogramId?)` | Creates an activity for a grade |

After seeding, access created entities via `seeder.Activities` (list of all seeded activities).

## Available Seeders

| Seeder | Description |
|--------|-------------|
| `EmptyDb` | No data — tests "empty" and "not found" scenarios |
| `BaseCaseDb` | Seeds 1 citizen activity (citizenId=1) and 1 grade activity (gradeId=1), both with pictogramId=1 |

To add a new seeder, create a class extending `DbSeeder` and override `SeedData(dbContext)`.

## TestJwtToken & Authentication

`TestJwtToken.Build(claims)` creates a JWT with:
- Issuer: `TestIssuer`
- Audience: `TestAudience`
- Key: `ThisIsASecretKeyForTestingPurposes!`
- Expires in 1 hour

Use `client.AttachClaimsToken(role: "member")` to authenticate an `HttpClient`. Parameters:
- `userId` (default: `"test-user-id"`)
- `role` (default: `"member"`) — sets the `org_roles` claim
- `orgId` (default: `1`)

The token includes `user_id`, `sub`, `ClaimTypes.NameIdentifier`, and `org_roles` claims.

## StubCoreClient

When `GirafWebApplicationFactory(stubCoreClient: true)` is used, the real `GirafCoreClient` HTTP calls are replaced with `StubCoreClient`:
- IDs 1–100 → validation returns `true`
- IDs > 100 → validation returns `false`

Use this for any test that creates activities or assigns pictograms (which validate against giraf-core).

## Writing a New Integration Test

```csharp
[Fact]
public async Task MyEndpoint_ReturnsExpected()
{
    // 1. Create factory (use stubCoreClient: true if endpoint validates with giraf-core)
    var factory = new GirafWebApplicationFactory(stubCoreClient: true);
    var seeder = new BaseCaseDb();
    var scope = factory.Services.CreateScope();
    factory.SeedDb(scope, seeder);
    var client = factory.CreateClient();

    // 2. Authenticate
    client.AttachClaimsToken(role: "admin");

    // 3. Act
    var response = await client.GetAsync("/your/endpoint");

    // 4. Assert
    response.EnsureSuccessStatusCode();
    var result = await response.Content.ReadFromJsonAsync<YourDTO>();
    Assert.NotNull(result);
}
```

**Key points:**
- Each test gets its own factory/DB — no shared state between tests
- Use `EmptyDb` for "not found" / empty scenarios
- Use `BaseCaseDb` for happy-path scenarios with existing data
- Factory disposes DB files automatically, but if tests fail mid-run, leftover `GirafTestDb_*.db` files may accumulate — they are gitignored
