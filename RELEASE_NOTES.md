# Release Notes

## 5.0.3 - 2026-03-01

Highlights:
- Add `Package.swift` manifests for iOS and macOS under the plugin package layout expected by Flutter tooling.
- Add Swift source targets for SPM with equivalent method-channel behavior.

Notes:
- No Dart API changes; this release improves Apple platform package integration metadata.

## 5.0.2 - 2026-03-01

Highlights:
- Improve pub.dev package page quality with updated README badges and installation snippet.
- Replace the generic example README with clear package-specific guidance.
- Align repository metadata checks for the next pub.dev analysis run.

Notes:
- No API changes; this is a documentation and release-quality update.

## 5.0.1 - 02/09/2026

Highlights:
- Fix Android plugin registration by aligning the main class location with the Android package.
- Add `lib/country_codes_plus.dart` entrypoint and keep the legacy entrypoint as a re-export.
- Refresh dev dependency tooling (update `lints` to 6.1.0 and related transitive updates).

Notes:
- No API changes; this is a patch release to address Android plugin discovery.

## 5.0.0 - 02/09/2026

Highlights:
- Package renamed to `country_codes_plus` (update imports and dependency names).
- Example app and platform configs aligned with the new package name.

Notes:
- This is a breaking change for consumers using `country_codes_plus`.

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
