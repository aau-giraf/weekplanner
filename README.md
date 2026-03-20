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
| `frontend/` | Flutter, Provider, GoRouter, Dio | MVVM app — login, org/citizen picker, week view, activity CRUD |
| `backend/` | .NET 10 Minimal API, EF Core, PostgreSQL | Activity CRUD with giraf-core JWT validation |

## Testing

```bash
# Frontend (62 tests)
cd frontend && flutter test

# Backend (21 integration tests)
cd backend && dotnet test
```

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

## Frontend Architecture

MVVM with Provider + ChangeNotifier, following [Flutter's app architecture guide](https://docs.flutter.dev/app-architecture/guide).

```
frontend/lib/
├── main.dart                  # Entry point, Provider setup
├── app.dart                   # MaterialApp + GoRouter
├── config/                    # API URLs, theme
├── shared/
│   ├── models/                # Freezed data classes (Activity, Citizen, etc.)
│   ├── services/              # Dio API clients (core + weekplanner)
│   └── utils/                 # JWT decode, date helpers
└── features/
    ├── auth/                  # Login, JWT storage, auth redirect
    ├── organisation_picker/   # Org list → citizen/grade selection
    └── weekplan/              # Week view, activity CRUD, pictogram selector
```

## Key Design Decisions

- **Two API clients**: separate Dio instances for giraf-core and weekplanner backend, matching the dual-backend architecture
- **JWT claim**: user ID is in the `user_id` claim (ninja-jwt default), not `sub`
- **Optimistic updates**: activity delete and toggle update the UI immediately, rolling back on API failure
- **Pagination**: giraf-core uses `{items: T[], count: number}` with `limit`/`offset`; weekplanner returns plain arrays
