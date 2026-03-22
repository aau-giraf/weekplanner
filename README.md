# Weekplanner

Schedule management app for the GIRAF ecosystem — helps children with autism manage their weekly activities using pictograms.

## Architecture

```
Flutter app (frontend/)
       │
       ├──→ Weekplanner API (backend/)    .NET 10, activity CRUD only
       │         │
       │         └──→ PostgreSQL (port 5433)
       │
       └──→ GIRAF Core API (external)     Users, orgs, citizens, pictograms
                 │
                 └──→ PostgreSQL (port 5432)
```

The weekplanner backend stores only **Activities**. All shared entities (users, organizations, citizens, grades, pictograms) are managed by [giraf-core](https://github.com/aau-giraf/giraf-core). JWTs issued by Core are validated locally using a shared `JWT_SECRET`.

## Quick Start

### 1. Start the full stack

Use [giraf-deploy](https://github.com/aau-giraf/giraf-deploy) to run everything:

```bash
cd ../giraf-deploy
docker compose up -d
```

This starts giraf-core (`:8000`), weekplanner backend (`:5171`), and their databases.

### 2. Create a test user

```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H 'Content-Type: application/json' \
  -d '{"username":"test@giraf.dk","password":"GirafUgeplan2025","email":"test@giraf.dk","first_name":"Test","last_name":"User"}'
```

### 3. Create a test organisation

```bash
TOKEN=$(curl -s -X POST http://localhost:8000/api/v1/token/pair \
  -H 'Content-Type: application/json' \
  -d '{"username":"test@giraf.dk","password":"GirafUgeplan2025"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['access'])")

curl -X POST http://localhost:8000/api/v1/organizations \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"name":"Test Organisation"}'
```

### 4. Run the Flutter app

```bash
cd frontend
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d linux \
  --dart-define=CORE_BASE_URL=http://localhost:8000 \
  --dart-define=WEEKPLANNER_BASE_URL=http://localhost:5171
```

For Android emulator, omit the `--dart-define` flags (defaults to `10.0.2.2`).

Log in with `test@giraf.dk` / `GirafUgeplan2025`.

## Project Structure

| Directory | Stack | Description |
|-----------|-------|-------------|
| `frontend/` | Flutter, BLoC/Cubit, GoRouter, Dio, fpdart | Login, org/citizen picker, week view, activity CRUD |
| `backend/` | .NET 10 Minimal API, EF Core, PostgreSQL | Activity CRUD — see [backend/docs/architecture.md](backend/docs/architecture.md) |

## Coding Standards

**We strictly follow official Dart and Flutter conventions.** Before contributing, read:

- [Effective Dart](https://dart.dev/effective-dart) — naming, style, usage, design, documentation
- [Flutter Architecture Guide](https://docs.flutter.dev/app-architecture/guide) — layered architecture with BLoC
- [BLoC Library](https://bloclibrary.dev) — state management patterns

All code must pass `dart analyze` with zero warnings.

## Frontend Architecture

BLoC/Cubit with feature-first structure. Dependencies flow one way: **View → Cubit → Repository → Service**.

- **Views** render state and forward user intent. No business logic.
- **Cubits** manage feature state. Emit sealed state classes. Pure Dart — no Flutter imports.
- **Repositories** are the data boundary. Return `Either<Failure, T>` (fpdart). Never throw.
- **Services** are stateless Dio wrappers. One per external API.
- **Models** are immutable (`freezed` + `json_serializable`).

### Package Structure

```
frontend/lib/
├── main.dart                  # Entry point, BlocProvider/Provider setup
├── app.dart                   # MaterialApp + GoRouter
├── config/                    # API URLs, theme
├── core/
│   ├── errors/                # Typed failure hierarchies
│   └── routing/               # GoRouter helpers
├── shared/
│   ├── models/                # Freezed data classes (Activity, Citizen, etc.)
│   ├── services/              # Dio API clients (core + weekplanner)
│   └── utils/                 # JWT decode, date helpers
└── features/
    ├── auth/                  # Login, JWT storage, auth redirect
    ├── organisation_picker/   # Org list → citizen/grade selection
    └── weekplan/              # Week view, activity CRUD, pictogram selector
```

Each feature is organized by layer: `domain/` (states, entities), `data/repositories/`, `presentation/` (cubits, views, widgets).

## Adding a New Feature

Follow the existing structure. Here's how to add a feature called `settings`:

### 1. Create the directory skeleton

```
frontend/lib/features/settings/
├── domain/
│   └── settings_state.dart          # Sealed state hierarchy
├── data/
│   └── repositories/
│       └── settings_repository.dart  # Pure data, returns Either<Failure, T>
└── presentation/
    ├── settings_cubit.dart           # State management (pure Dart, no Flutter)
    ├── views/
    │   └── settings_view.dart        # Top-level screen
    └── widgets/
        └── settings_card.dart        # Extracted sub-widgets
```

### 2. Define failures and state

Create a sealed failure type in `lib/core/errors/settings_failure.dart`:

```dart
sealed class SettingsFailure {
  final String message;
  const SettingsFailure(this.message);
}
final class FetchSettingsFailure extends SettingsFailure {
  const FetchSettingsFailure() : super('Kunne ikke hente indstillinger');
}
```

Create a sealed state hierarchy in `domain/settings_state.dart` — extend `Equatable`:

```dart
sealed class SettingsState extends Equatable { ... }
final class SettingsLoading extends SettingsState { ... }
final class SettingsLoaded extends SettingsState { ... }
final class SettingsError extends SettingsState { ... }
```

### 3. Write the repository

Repositories are the data boundary. They call services and return `Either<Failure, T>` — never throw:

```dart
class SettingsRepository {
  Future<Either<SettingsFailure, Settings>> fetchSettings() async {
    try {
      final data = await _apiService.getSettings();
      return Right(data);
    } catch (e, stackTrace) {
      _log.severe('Failed to fetch settings', e, stackTrace);
      return Left(const FetchSettingsFailure());
    }
  }
}
```

### 4. Write the cubit

Cubits are pure Dart — no Flutter imports. Use `switch` on `Either`, never `fold` with async:

```dart
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required SettingsRepository repository})
      : _repository = repository, super(const SettingsLoading());

  Future<void> load() async {
    emit(const SettingsLoading());
    final result = await _repository.fetchSettings();
    switch (result) {
      case Left(:final value):
        emit(SettingsError(message: value.message));
      case Right(:final value):
        emit(SettingsLoaded(settings: value));
    }
  }
}
```

### 5. Write the view

Views use `BlocBuilder` for UI and `BlocListener` for side effects. Read colors from the theme, not `GirafColors`:

```dart
class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => switch (state) {
        SettingsLoading() => const Center(child: CircularProgressIndicator()),
        SettingsLoaded(:final settings) => _SettingsContent(settings: settings),
        SettingsError(:final message) => Center(child: Text(message)),
      },
    );
  }
}
```

Extract sub-trees into separate `StatelessWidget` classes, not private `_build` methods.

### 6. Add the route

In `lib/app.dart`, add a `GoRoute` and provide the cubit via `BlocProvider`:

```dart
GoRoute(
  path: '/settings',
  builder: (context, state) => BlocProvider(
    create: (_) => SettingsCubit(repository: settingsRepo)..load(),
    child: const SettingsView(),
  ),
),
```

### 7. Write tests

Every feature needs three levels of tests:

| Test | What to test | Tools |
|------|-------------|-------|
| `settings_repository_test.dart` | Right/Left for each method | mocktail |
| `settings_cubit_test.dart` | State transitions for each action | bloc_test, mocktail |
| `settings_view_test.dart` | All visual states (loading, loaded, error) | MockCubit, pumpWidget |

Follow existing tests in `test/features/weekplan/` for patterns.

## Testing

```bash
# Frontend
cd frontend && flutter test

# Backend (integration tests)
cd backend && dotnet test
```

- **mocktail** for mocking (no codegen)
- **bloc_test** for cubit tests
- Widget tests for all views
- Arrange → Act → Assert pattern

## API Endpoints

### giraf-core (`:8000`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/token/pair` | Login (returns JWT) |
| POST | `/api/v1/auth/register` | Register user |
| GET | `/api/v1/organizations` | List user's organisations |
| GET | `/api/v1/organizations/:id/citizens` | List citizens in org |
| GET | `/api/v1/organizations/:id/grades` | List grades in org |
| GET | `/api/v1/pictograms` | Search pictograms |

### weekplanner backend (`:5171`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/weekplan/:citizenId?date=YYYY-MM-DD` | Activities for citizen on date |
| GET | `/weekplan/grade/:gradeId?date=YYYY-MM-DD` | Activities for grade on date |
| POST | `/weekplan/to-citizen/:citizenId` | Create activity for citizen |
| POST | `/weekplan/to-grade/:gradeId` | Create activity for grade |
| PUT | `/weekplan/activity/:id` | Update activity |
| DELETE | `/weekplan/activity/:id` | Delete activity |
| PUT | `/weekplan/activity/:id/iscomplete` | Toggle completion |

## Key Design Decisions

- **Two API clients**: separate Dio instances for giraf-core and weekplanner backend, matching the dual-backend architecture
- **JWT claim**: user ID is in the `user_id` claim (ninja-jwt default), not `sub`
- **Optimistic updates**: activity delete and toggle update the UI immediately, rolling back on API failure
- **Pagination**: giraf-core uses `{items: T[], count: number}` with `limit`/`offset`; weekplanner returns plain arrays
