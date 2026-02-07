# Country Codes

A Flutter/Dart plugin that provides country details (ISO codes, dial codes, names) based on a `Locale`.

## Features
- Resolve country details from device locale or a provided `Locale`.
- Access ISO 3166 alpha-2/alpha-3 codes and dial codes.
- Optional localized country names with `init`.
- Input formatter for phone dial codes.

## Installation
Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  country_codes: ^4.0.0
```

Then run:

```bash
flutter pub get
```

## Usage
### Initialize (device locale)
```dart
await CountryCodes.init();

final Locale deviceLocale = CountryCodes.getDeviceLocale();
final CountryDetails details = CountryCodes.detailsForLocale();

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

### Error handling
```dart
final name = CountryCodes.name(
  locale: const Locale('xx', 'YY'),
  onInvalidLocale: () => debugPrint('Invalid locale'),
);
```

## Formatters
### `DialCodeFormatter`
```dart
TextFormField(
  keyboardType: TextInputType.phone,
  inputFormatters: [DialCodeFormatter()],
);
```

## Platform support
- Android, iOS, macOS: supported
- Web: not officially supported (avoid calling `init` on web)

## License
MIT
