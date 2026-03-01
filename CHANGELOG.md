## [5.0.3] - 2026-03-01
* Add Swift Package Manager manifests for iOS and macOS plugin targets.
* Add Swift sources for SPM targets using the same platform channel behavior as existing plugin code.

## [5.0.2] - 2026-03-01
* Improve package documentation for pub.dev (README badges and install instructions).
* Replace default example README with package-specific usage notes.
* Keep repository metadata aligned for pub.dev score validation.

## [5.0.1] - 02/09/2026
* Fix Android plugin registration by aligning the main class location with the Android package.
* Add `country_codes_plus.dart` entrypoint and keep the legacy entrypoint as a re-export.
* Update `lints` to 6.1.0 and refresh transitive dev dependencies.

## [5.0.0] - 02/09/2026
* Rename package to `country_codes_plus` and align platform/podspec identifiers.
* Update example app and docs to use the new package name.

## [4.0.0] - 02/07/2026
* Improve locale fallback for language-only locales and fix Timor-Leste alpha2 code.
* Update Android locale selection for multi-locale devices; use auto-updating locales on iOS/macOS.
* Target Java 17 bytecode and update Android Gradle/AGP/Kotlin tooling.
* Migrate Android example Gradle files to Flutter plugins DSL.
* Disable Jetifier in the example app after AndroidX verification.
* Add validation/platform-channel tests plus linting and CI checks.
* Document locale edge cases and web support limitations.

## [3.3.0] - 02/13/2025
* Removed old pre-Flutter-1.12 Android project plugin method `registerWith` which has been removed from flutter 3.29.0

## [3.2.3+1] - 06/02/2025
* Add onInvalidLocale callback to `name` method.

## [3.2.2+3] - 31/01/2025
* Fix minor regression where `init` would fail if the device's locale was null.

## [3.2.2] - 31/01/2025
* Handles an issue where the country code could not be resolved and an exception was thrown.

## [3.2.1] - 29/01/2025
* Address an issue where init could use an empty list.

## [3.2.0] - 14/05/2024
* Adds sub regions.
* Addresses an issue when the code could not be resolved and an exception was thrown.

## [3.1.0] - 14/05/2024
* Adds `countryCode` property.

## [3.0.0] - 13/05/2024
* Adds Android namespace and other minor improvements.

## [2.2.0] - 10/05/2022

* Upgrades to Android project (pre 1.12). Thank you @vergardan.

## [2.1.1] - 21/10/2021

* Fixes Sint Marteen code.

## [2.1.0] - 17/10/2021

* Adds a method to get a `List` with all country's details.

## [2.0.1] - 25/03/2021

* Updates gradle to 5.4.1.

## [2.0.0] - 25/03/2021

* Updates to null safety. Thank you @AntonyLeons.

## [1.0.3] - 17/11/2020

* Adds new codes from Netherlands Antilles dissolution.
## [1.0.2] - 20/10/2020

* Fixes dial code for Shqipëria.

## [1.0.1] - 05/08/2020

* Sets default `Locale` to en-US whenever a device hasn't a default locale set (typically will happen only on iOS simulators).

## [1.0.0+1] - 08/07/2020

* Updates assert to also validate that `countryCode` is not `null`.

## [1.0.0] - 10/05/2020

* Added `localizedName` property to `CountryDetails`. This allows you to display any country name base on a `Locale` language. Must be set when doing `CountryCodes.init(locale)`, defaults to device's language.
* Updated Android `compileSdkVersion` to 29 and `minSdkVersion` to 21;
* Updated example app;

## [0.1.0] - 13/02/2020

Exposes device `Locale` (language and country code) instead of country only.

## [0.0.6+2] - 12/02/2020

Updates `dialCode()` to receive the [locale] optionally instead of explictly `null` in order to retrieve the device's region dial code.

## [0.0.6+1] - 03/02/2020

Replaces `FutureOr<Locale>` with `Locale` to make it explicitly synchronous when invoking `getDeviceLocale()`

## [0.0.6] - 03/02/2020

Exposes device's `Locale` through `getDeviceLocale()` method.

## [0.0.5] - 31/01/2020

Updates README

## [0.0.4] - 31/01/2020

* Adds default `locale` from device region when not provided. For this to work, please call `CountryCodes.init()` before invoking other methods.
* Overall minor improvements.

## [0.0.3] - 30/01/2020

Format

## [0.0.2] - 30/01/2020

Adds license (MIT)

## [0.0.1] - 30/01/2020

Initial release. Provides access to `DialCodeFormatter` for `TextFormField`s, `alpha2Code`, `dialCode` and `name`.
