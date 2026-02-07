# Release Notes

## 4.0.0 - 02/07/2026

Highlights:
- Locale fallback improvements for language-only locales (e.g., `Locale('en')` defaults to `US`) with tests.
- Android locale selection now respects multi-locale priority; iOS/macOS use auto-updating locales.
- Added validation tests for ISO/dial codes and platform channel init.
- CI now runs `dart analyze`, unit tests, and example builds for Android/iOS.
- Documentation updates covering edge cases and web support limitations.
- Android build now targets Java 17 bytecode for Kotlin/Java sources.
- Updated Android Gradle tooling (AGP/Kotlin/Gradle) and migrated the example to Flutter's plugins DSL.
- Disabled Jetifier for the example app after verifying all dependencies are AndroidX.

Notes:
- API remains compatible with 3.3.x for typical usage.
