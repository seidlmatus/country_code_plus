# country_codes_plus

A Flutter plugin that provides country details (ISO codes, dial codes, names) based on a `Locale`.

[![CI](https://github.com/seidlmatus/country_code_plus/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/seidlmatus/country_code_plus/actions/workflows/ci.yml)
[![pub package](https://img.shields.io/pub/v/country_codes_plus.svg)](https://pub.dev/packages/country_codes_plus)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-FFDD00?logo=buymeacoffee&logoColor=000000)](https://buymeacoffee.com/seidlmatus2)

> Support development: **[Buy Me a Coffee](https://buymeacoffee.com/seidlmatus2)**

## Features
- Resolve country details from device locale or a provided `Locale`.
- Use rich lookup status API with `CountryCodes.lookupDetails()`.
- Access ISO 3166 alpha-2/alpha-3 codes and dial codes.
- Access ISO 3166-2 subdivisions for supported countries.
- Search subdivisions and list subdivision types by country.
- Optional localized country names with `init`.
- Configurable input formatter for phone dial codes.

## Installation
Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  country_codes_plus: ^5.1.0
```

Then run:

```bash
flutter pub get
```

## Compatibility Matrix
| Component | Supported |
| --- | --- |
| Dart SDK | `>=3.0.0 <4.0.0` |
| Flutter SDK | `>=3.7.0` |
| Android | Supported |
| iOS | Supported |
| macOS | Supported |
| Web | Not officially supported (`init` should be avoided on web) |

## Quick Start
```dart
import 'package:country_codes_plus/country_codes_plus.dart';

Future<void> setup() async {
  final initialized = await CountryCodes.init();
  if (!initialized) return;

  final locale = CountryCodes.getDeviceLocale();
  final details = CountryCodes.detailsForLocale();
  if (locale == null) return;

  print(locale); // e.g. en_US
  print(details.alpha2Code); // e.g. US
  print(details.alpha3Code); // e.g. USA
  print(details.dialCode); // e.g. +1
  print(details.name); // e.g. United States
}
```

## Usage
Import the package:

```dart
import 'package:country_codes_plus/country_codes_plus.dart';
```

### Initialize (device locale)
```dart
final initialized = await CountryCodes.init();
if (!initialized) return;

final Locale? deviceLocale = CountryCodes.getDeviceLocale();
final CountryDetails details = CountryCodes.detailsForLocale();
if (deviceLocale == null) return;

print(details.alpha2Code); // e.g. US
print(details.alpha3Code); // e.g. USA
print(details.dialCode);   // e.g. +1
print(details.name);       // e.g. United States
print(details.localizedName); // localized if init() received an app locale
```

### Use a custom `Locale`
```dart
final CountryDetails details =
    CountryCodes.detailsForLocale(const Locale('pt', 'PT'));

print(details.alpha2Code); // PT
print(details.dialCode);   // +351
print(details.name);       // Portugal
```

### Locale without region
If a `Locale` has no country (e.g. `Locale('en')`), the package tries to infer a country from language.
English defaults to `US`.

### Lookup by alpha-2 code
```dart
final CountryDetails sk = CountryCodes.detailsFromAlpha2('SK');
print(sk.dialCode); // +421
```

### Subdivisions (ISO 3166-2)
```dart
final skSubdivisions = CountryCodes.subdivisionsForCountry('SK');
print(skSubdivisions.first.code); // e.g. SK-BL

final subdivision = CountryCodes.subdivisionFromCode('CZ-10');
print(subdivision?.name); // Hlavni mesto Praha

final matches = CountryCodes.searchSubdivisions(
  'praha',
  countryAlpha2: 'CZ',
  limit: 5,
);
print(matches.map((entry) => entry.code).toList());

final skTypes = CountryCodes.subdivisionTypesForCountry('SK');
print(skTypes); // e.g. [Kraj]
```

### Error handling
```dart
final details = CountryCodes.detailsForLocaleOrNull(const Locale('xx', 'YY'));
if (details == null) {
  debugPrint('Invalid locale');
}

final name = CountryCodes.name(
  locale: const Locale('xx', 'YY'),
  onInvalidLocale: () => debugPrint('Invalid locale'),
);
```

### Rich lookup result
```dart
final lookup = CountryCodes.lookupDetails(const Locale('sk', 'SK'));
if (lookup.isSuccess) {
  print(lookup.details?.name); // Slovakia
} else {
  print(lookup.status); // localeUnavailable / countryNotSupported
}
```

## Formatters
### `DialCodeFormatter`
```dart
TextFormField(
  keyboardType: TextInputType.phone,
  inputFormatters: [DialCodeFormatter()],
);

TextFormField(
  keyboardType: TextInputType.phone,
  inputFormatters: [DialCodeFormatter(const Locale('sk', 'SK'), ' ')],
);

TextFormField(
  keyboardType: TextInputType.phone,
  inputFormatters: [
    DialCodeFormatter(
      const Locale('sk', 'SK'),
      '',
      false, // force package dial code even if user types another +prefix
    ),
  ],
);
```

## Platform support
- Android, iOS, macOS: supported
- Web: not officially supported (avoid calling `init` on web)
- Swift Package Manager manifests are included for iOS and macOS plugin targets.

## Migration
- If you are upgrading from `country_codes`, update dependency and imports to `country_codes_plus`.
- Legacy import `package:country_codes_plus/country_code_plus.dart` remains available as a re-export.

## Example App
- See the example app in [`example/`](example).

## Donate
If this package saves you time, you can support maintenance here:

**[buymeacoffee.com/seidlmatus2](https://buymeacoffee.com/seidlmatus2)**

## Contributing
- PRs are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.
- Use issue templates for bug reports and feature requests.

## Security
- For vulnerability reporting, see [SECURITY.md](SECURITY.md).

## License
MIT, see [LICENSE](LICENSE).
