# Contributing to Weekplanner

For general workflow and guidelines, see the [organization CONTRIBUTING.md](https://github.com/aau-giraf/.github/blob/main/CONTRIBUTING.md).

## Development Setup

### Prerequisites

- .NET 8 SDK
- Node.js 18+
- Docker (for PostgreSQL)
- A running [giraf-core](https://github.com/aau-giraf/giraf-core) instance

### Backend

```bash
docker compose up             # API on :5171 + PostgreSQL
dotnet test backend/          # Run tests
```

### Frontend

```bash
cd frontend
npm install
npx expo start                # Dev server
npm run test                  # Jest tests
npm run lint                  # ESLint
```

The frontend calls both the Weekplanner API (for activities) and the Core API (for users, citizens, pictograms) directly.
