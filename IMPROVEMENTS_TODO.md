# Improvements TODO

Status values: `todo`, `in_progress`, `blocked`, `done`.

## Current pub.dev deployment audit - 2026-05-31

- pub.dev latest stable version: `5.1.0`.
- Local `pubspec.yaml` version: `5.1.1`.
- Deployment status: local package is prepared as the next patch release; publish `5.1.1` after review.
- Verification run:
  - `flutter test`: passing.
  - `flutter pub publish --dry-run`: package validation passes; current run reports the expected warning that release changes are not committed yet.
  - `dart analyze`: passing after cleanup.
  - `flutter pub outdated`: direct dependencies are up to date; remaining outdated packages are transitive and constrained by the Flutter test stack.

## Next TODO

| ID | Platform | Area | Description | Status | Priority | Owner | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CC-013 | All | Maintenance | Fix analyzer info findings in `lib/src/country_codes.dart` and `lib/src/country_details.dart`. | done | P1 | | Removed unnecessary string escapes and `this.` qualifiers; `dart analyze` is clean. |
| CC-014 | All | Dependencies | Refresh package lockfiles with `flutter pub upgrade` for root and example, then rerun analyze/test/dry-run. | done | P2 | | Lockfiles refreshed. Remaining outdated packages are transitive and constrained by Flutter tooling. |
| CC-015 | All | API Compatibility | Export `src/subdivision_details.dart` from legacy `lib/country_codes.dart`. | done | P1 | | Added legacy export and regression test in `test/legacy_entrypoint_test.dart`. |
| CC-016 | All | Performance | Avoid rebuilding all `CountrySubdivision` objects for every global subdivision search. | done | P2 | | Added a cached `_allSubdivisions` list and kept `subdivisions()` returning a fresh list copy. |
| CC-017 | All | Data Model | Reduce repeated dynamic map conversions around country data. | done | P2 | | Tightened `codes` typing to `Map<String, Map<String, String>>` and removed repeated casts. |
| CC-018 | All | Locale | Add tests for sub-region fallback and empty-region `init()` responses. | done | P2 | | Added regression tests for `AC -> SH` fallback and empty-region platform payload fallback. |
| CC-019 | All | Docs | Fix small documentation typo in `CountryCodes.name()` comment. | done | P3 | | Fixed `exended` to `extended`. |
| CC-020 | All | Release | If any user-facing API/export behavior changes, add the next `CHANGELOG.md` and `RELEASE_NOTES.md` entry before publishing. | done | P1 | | Added `5.1.1` entries and bumped package/docs version. |
| CC-021 | All | API | Add country search and lookup helpers for alpha-3 and dial-code use cases. | done | P2 | | Added `allCountries`, `searchCountries()`, `detailsFromAlpha3()`, `countriesFromDialCode()`, and `countryFromDialCode()`. |
| CC-022 | All | DX | Add value equality, `hashCode`, and `toString()` to public model classes. | done | P2 | | Implemented for `CountryDetails`, `CountryLookupResult`, and `CountrySubdivision`. |
| CC-023 | All | Release | Document the release checklist. | done | P3 | | Added `RELEASING.md`. Existing CI/publish workflows already cover checks and publish automation. |

## Completed historical TODO

| ID | Platform | Area | Description | Status | Priority | Owner | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CC-001 | All | API | Review public API surface and remove any deprecated or unused exports in `lib/country_codes_plus.dart`. | done | P2 | | No deprecated or unused exports found to remove. |
| CC-002 | All | Data | Add validation tests for ISO code mappings and dial codes in `lib/src/codes.dart`. | done | P1 | | Added validation tests in `test/country_codes_test.dart`. |
| CC-003 | All | Locale | Improve locale fallback logic when region is missing (e.g., `en` only). | done | P1 | | Added language-only fallback with `en` default and tests. |
| CC-004 | All | Docs | Expand README usage section with error/edge-case examples. | done | P3 | | Added locale-without-region note and `onInvalidLocale` example. |
| CC-005 | Android | Platform | Verify locale retrieval on Android 13+ (multi-locale list) and handle priority correctly. | done | P1 | | Use configuration locales with priority and updated display locale logic. |
| CC-006 | Android | CI | Add basic Android plugin compile check in CI. | done | P2 | | Added GitHub Actions job to build Android example APK. |
| CC-007 | iOS | Platform | Ensure locale retrieval supports iOS region changes without app restart. | done | P1 | | Switched to `Locale.autoupdatingCurrent` and updated display locale resolution. |
| CC-008 | iOS | CI | Add iOS build check for example app. | done | P2 | | Added macOS GitHub Actions job with `flutter build ios --no-codesign`. |
| CC-009 | macOS | Platform | Validate macOS locale updates and add a unit test stub for platform channel responses. | done | P2 | | Updated macOS to use `Locale.autoupdatingCurrent` and added platform channel mock test. |
| CC-010 | Web | Support | Evaluate feasibility of web implementation using `window.navigator.language` and document limitations. | done | P2 | | Documented that web is not officially supported and `init` should be avoided. |
| CC-011 | Web | Tests | Add a web-specific test for locale parsing if web support is enabled. | done | P3 | | Not applicable since web support is not enabled. |
| CC-012 | All | Quality | Add `analysis_options.yaml` with standard lints and enable `dart analyze` in CI. | done | P2 | | Added `analysis_options.yaml`, `lints` dev dependency, and CI analyze step. |
