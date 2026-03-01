# country_codes_plus example

Minimal Flutter app that demonstrates how to initialize `country_codes_plus`
and display country data resolved from the current locale.

## Run

```bash
flutter pub get
flutter run
```

## What it shows

- `CountryCodes.init()` initialization flow
- reading device locale with `CountryCodes.getDeviceLocale()`
- resolving country details (`alpha2`, `alpha3`, dial code, name)
- listing subdivisions via `CountryCodes.subdivisionsForCountry(alpha2)`
- finding one subdivision by code via `CountryCodes.subdivisionFromCode(code)`
