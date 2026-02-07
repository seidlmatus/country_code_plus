# Repository Guidelines

## Project Structure & Module Organization
- `lib/` contains the public package API and implementation. `lib/country_codes.dart` is the main entry point; `lib/src/` holds internal helpers like `country_details.dart` and `dial_code_formatter.dart`.
- `test/` holds package tests (currently `test/country_codes_test.dart`).
- `example/` is a sample Flutter app demonstrating usage and includes its own `pubspec.yaml` and platform folders.
- `android/`, `ios/`, and `macos/` contain the Flutter plugin platform implementations.

## Build, Test, and Development Commands
- `flutter pub get` installs dependencies for the package or the example app.
- `flutter test` runs all package tests under `test/`.
- `flutter test test/country_codes_test.dart` runs a specific test file.
- `dart format .` formats Dart code using the standard formatter.
- `dart analyze` runs the Dart analyzer using `analysis_options.yaml` and `package:lints`.

## Coding Style & Naming Conventions
- Use standard Dart formatting (`dart format`) and idiomatic Dart naming: `UpperCamelCase` for types, `lowerCamelCase` for variables/functions, and `snake_case` for file names.
- Keep public API surface in `lib/` minimal and re-export from `lib/country_codes.dart`.
- Avoid introducing breaking changes without updating `CHANGELOG.md` and `pubspec.yaml` version.

## Testing Guidelines
- Tests use the Flutter test framework via `flutter_test`.
- Name tests descriptively and keep them in `test/` with `*_test.dart` filenames.
- Prefer unit tests for locale parsing, country lookups, and formatter behavior.

## Release Notes
- Always add or update a release entry in `RELEASE_NOTES.md` for each published version.
- Keep release notes focused on user-facing changes, migrations, and platform-specific impacts.

## Configuration & Platforms
- This is a Flutter plugin targeting Android, iOS, and macOS; validate platform changes locally before publishing.
- Keep platform-specific logic contained to their respective folders and expose consistent behavior through the Dart API.
