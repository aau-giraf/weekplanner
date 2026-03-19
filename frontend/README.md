# Weekplanner Frontend (Flutter)

Flutter app for the GIRAF Weekplanner — schedule management for children with autism.

## Prerequisites

- Flutter SDK (3.38+)
- Running giraf-deploy stack (`docker compose up` from `giraf-deploy/`)

## Running

```bash
# Start the backend stack
cd ../giraf-deploy && docker compose up -d

# Run the Flutter app (Linux desktop)
cd frontend
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d linux \
  --dart-define=CORE_BASE_URL=http://localhost:8000 \
  --dart-define=WEEKPLANNER_BASE_URL=http://localhost:5171
```

For Android emulator, omit the `--dart-define` flags (defaults to `10.0.2.2`).

## Setting up test data

Register a user:

```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H 'Content-Type: application/json' \
  -d '{"username":"test@giraf.dk","password":"GirafUgeplan2025","email":"test@giraf.dk","first_name":"Test","last_name":"User"}'
```

Create an organisation (need a token first):

```bash
TOKEN=$(curl -s -X POST http://localhost:8000/api/v1/token/pair \
  -H 'Content-Type: application/json' \
  -d '{"username":"test@giraf.dk","password":"GirafUgeplan2025"}' | python3 -c "import sys,json; print(json.load(sys.stdin)['access'])")

curl -X POST http://localhost:8000/api/v1/organizations \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"name":"Test Organisation"}'
```

Then log in with `test@giraf.dk` / `GirafUgeplan2025`.

## Tests

```bash
flutter test
```

## Architecture

MVVM with Provider + ChangeNotifier, following [Flutter's app architecture guide](https://docs.flutter.dev/app-architecture/guide).

```
lib/
├── main.dart                  # Entry point, Provider setup
├── app.dart                   # MaterialApp + GoRouter
├── config/                    # API URLs, theme
├── shared/
│   ├── models/                # Freezed data classes
│   ├── services/              # Dio API clients (core + weekplanner)
│   └── utils/                 # JWT decode, date helpers
└── features/
    ├── auth/                  # Login, JWT storage
    ├── organisation_picker/   # Org → citizen/grade selection
    └── weekplan/              # Week view, activity CRUD, pictograms
```

Two separate API clients:
- **giraf-core** (`:8000`) — auth, organisations, citizens, grades, pictograms
- **weekplanner backend** (`:5171`) — activity CRUD
