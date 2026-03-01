# Improvements TODO

Status values: `todo`, `in_progress`, `blocked`, `done`.

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
