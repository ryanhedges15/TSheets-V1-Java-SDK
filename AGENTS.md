# Repository Guidelines

## Project Structure & Modules
- `Intuit.TSheets/`: Core .NET Standard 2.0 SDK. Key areas: `Api/`, `Client/`, `Model/`, `Properties/`.
- `Intuit.TSheets.Tests/`: MSTest unit tests organized by domain (e.g., `Unit/Api`, `Unit/Client`).
- `Intuit.TSheets.Examples/`: Minimal console app demonstrating SDK usage.
- `Documentation/` and `images/`: Ancillary docs and assets.
- `TSheets.sln`: Root Visual Studio/Dotnet solution.

## Build, Test, and Run
- Restore: `dotnet restore`
- Build (Debug): `dotnet build TSheets.sln -c Debug`
- Build (Release): `dotnet build TSheets.sln -c Release`
- Test: `dotnet test --no-build`
- Run example: `dotnet run --project Intuit.TSheets.Examples`
Notes: CI mirrors this with `dotnet restore` and `dotnet test` (see `.travis.yml`).

## Coding Style & Naming
- Language: C# (LangVersion `latest`). Target: `netstandard2.0`.
- Indentation: 4 spaces; one type per file; UTF-8.
- Namespaces: `Intuit.TSheets.*`.
- Types/Methods/Properties: PascalCase; locals/parameters: camelCase; constants: PascalCase (e.g., `AuthToken`).
- XML docs for public surface; adhere to StyleCop preferences (`Intuit.TSheets/Settings.StyleCop`). Avoid unnecessary `#pragma` by fixing warnings or adding justified entries in `GlobalSuppressions.cs`.

## Testing Guidelines
- Framework: MSTest (`Microsoft.NET.Test.Sdk`, `MSTest.TestFramework`).
- Location/Names: place tests under `Intuit.TSheets.Tests/Unit/...` with file names ending in `*Tests.cs`.
- Style: Arrange-Act-Assert; focus tests around API surface and serialization behaviors in `Model/`.
- Run selectively: `dotnet test --filter FullyQualifiedName~DataService_UsersTests`.

## Commits & Pull Requests
- Commits: short, imperative subject; include scope where helpful; reference issues (e.g., "Fix serialization for ProjectReportTotals (#26)").
- PRs: include summary, linked issues, rationale, and risk assessment. Add before/after notes for behavior changes; update `CHANGELOG.md` for user-visible changes.
- Requirements: build passes (`dotnet build`), tests green (`dotnet test`), no new StyleCop violations.

## Security & Configuration
- Do not commit secrets. For examples, replace the `AuthToken` placeholder at run time or inject via environment variable (e.g., `TSHEETS_AUTH_TOKEN`) and pass it to the example app.
- Validate logging does not leak tokens; prefer masked output at `Information` level.

