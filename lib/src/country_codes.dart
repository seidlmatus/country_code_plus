import 'dart:async';

import 'package:country_codes_plus/src/codes.dart';
import 'package:country_codes_plus/src/country_details.dart';
import 'package:country_codes_plus/src/country_lookup.dart';
import 'package:country_codes_plus/src/subdivision_details.dart';
import 'package:country_codes_plus/src/subdivisions.dart';
import 'package:country_codes_plus/src/sub_regions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CountryCodes {
  static const MethodChannel _channel = MethodChannel('country_codes_plus');
  static Locale? _deviceLocale;
  static Map<String, String> _localizedCountryNames = const {};

  static const Map<String, String> _languageDefaults = {
    'en': 'US',
  };

  static String? _resolveLocale(Locale? locale) {
    locale ??= _deviceLocale;
    if (locale == null) {
      assert(false, '''
         Locale cannot be null. If you are using an iOS simulator, please, make sure you go to region settings and select any country (even if it\'s already selected) because otherwise your country might be null.
         If you didn\'t provide one, please make sure you call init before using Country Details
        ''');
      return null;
    }

    String? countryCode = locale.countryCode?.toUpperCase();
    if (countryCode == null || countryCode.isEmpty) {
      countryCode = _countryCodeFromLanguage(locale.languageCode) ??
          _deviceLocale?.countryCode;
    }

    if (countryCode == null || countryCode.isEmpty) {
      assert(false, '''
         Locale country code cannot be null or empty. Provide a locale with a region (e.g. Locale('en', 'US'))
         or call init() to use the device locale.
        ''');
      return null;
    }

    if (!codes.containsKey(countryCode)) {
      countryCode = subRegionToCountryCode[countryCode] ?? countryCode;
    }

    return countryCode;
  }

  static String? _countryCodeFromLanguage(String languageCode) {
    final normalized = languageCode.toLowerCase();
    final defaultCountry = _languageDefaults[normalized];

    if (defaultCountry != null && codes.containsKey(defaultCountry)) {
      return defaultCountry;
    }

    final languageAsCountry = normalized.toUpperCase();
    if (codes.containsKey(languageAsCountry)) {
      final data = Map<String, dynamic>.from(codes[languageAsCountry] as Map);
      final countryCode = data['country_code'] as String?;
      if (countryCode != null && countryCode.startsWith('${normalized}_')) {
        return languageAsCountry;
      }
    }

    for (final entry in codes.entries) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      final countryCode = data['country_code'] as String?;
      if (countryCode != null && countryCode.startsWith('${normalized}_')) {
        return entry.key;
      }
    }

    return null;
  }

  /// Inits the underlying plugin channel and fetch current's device locale to be ready
  /// to use synchronously when required.
  ///
  /// If you never plan to provide a `locale` directly, you must call and await this
  /// by calling `await CountryCodes.init();` before accessing any other method.
  ///
  /// Optionally, you may want to provide your [appLocale] to access localized
  /// country name (eg. if your app is in English, display Italy instead of Italia).
  ///
  /// Example:
  /// ```dart
  /// CountryCodes.init(Localizations.localeOf(context))
  /// ```
  /// This will default to device's language if none is provided.
  static Future<bool> init([Locale? appLocale]) async {
    final dynamic response =
        await _channel.invokeMethod('getLocale', appLocale?.toLanguageTag());
    if (response is! List || response.length < 2) {
      return false;
    }

    final dynamic language = response[0];
    final dynamic region = response[1];
    if (language is! String || region is! String) {
      return false;
    }

    final String languageCode = language.trim().toLowerCase();
    String countryCode = region.trim().toUpperCase();

    if (countryCode.isEmpty) {
      countryCode = _countryCodeFromLanguage(languageCode) ?? '';
    }

    if (!codes.containsKey(countryCode)) {
      countryCode = subRegionToCountryCode[countryCode] ?? countryCode;
    }

    if (languageCode.isEmpty ||
        countryCode.isEmpty ||
        !codes.containsKey(countryCode)) {
      return false;
    }

    Map<String, String> localizedCountryNames = const {};
    if (response.length > 2 && response[2] is Map) {
      localizedCountryNames = Map<String, String>.from(
          (response[2] as Map).map((key, value) => MapEntry(
                key.toString().toUpperCase(),
                value?.toString() ?? '',
              )));
    }

    _deviceLocale = Locale(languageCode, countryCode);
    _localizedCountryNames = localizedCountryNames;
    return true;
  }

  /// Returns the current device's `Locale`
  /// Eg. `Locale('en','US')`
  static Locale? getDeviceLocale() {
    assert(_deviceLocale != null,
        'Please, make sure you call await init() before calling getDeviceLocale()');
    return _deviceLocale;
  }

  /// A list of dial codes for every country
  static List<String?> dialNumbers() {
    return codes.values
        .map((each) => CountryDetails.fromMap(each).dialCode)
        .toList();
  }

  /// A list of country data for every country
  static List<CountryDetails> countryCodes() {
    return codes.entries
        .map((entry) => CountryDetails.fromMap(
            entry.value, _localizedCountryNames[entry.key]))
        .toList();
  }

  /// Returns a list of subdivisions for the given country alpha-2 code.
  /// Codes follow ISO 3166-2 format (e.g. `SK-BL`, `CZ-10`).
  static List<CountrySubdivision> subdivisionsForCountry(String alpha2) {
    final normalizedAlpha2 = alpha2.toUpperCase();
    final entries = subdivisionsByCountry[normalizedAlpha2] ?? const [];
    return entries.map(CountrySubdivision.fromMap).toList();
  }

  /// Returns all available subdivisions across supported countries.
  static List<CountrySubdivision> subdivisions() {
    return subdivisionsByCountry.values
        .expand((entries) => entries)
        .map(CountrySubdivision.fromMap)
        .toList();
  }

  /// Returns subdivision details for an ISO 3166-2 subdivision code.
  /// Example: `SK-BL`, `CZ-10`.
  static CountrySubdivision? subdivisionFromCode(String subdivisionCode) {
    final normalizedCode = subdivisionCode.toUpperCase();
    final details = subdivisionsByCode[normalizedCode];
    if (details == null) {
      return null;
    }

    return CountrySubdivision.fromMap(details);
  }

  /// Returns the `CountryDetails` for the given [locale]. If not provided,
  /// the device's locale will be used instead.
  /// Have in mind that this is different than specifying `supportedLocale`s
  /// on your app.
  /// Exposed properties are the `name`, `alpha2Code`, `alpha3Code` and `dialCode`
  ///
  /// Example:
  /// ```dart
  /// "name": "United States",
  /// "alpha2Code": "US",
  /// "dial_code": "+1",
  /// ```
  static CountryDetails? detailsForLocaleOrNull([Locale? locale]) {
    return lookupDetails(locale).details;
  }

  /// Returns a rich lookup result for the given [locale] or current device locale.
  /// This method never throws.
  static CountryLookupResult lookupDetails([Locale? locale]) {
    if (locale == null && _deviceLocale == null) {
      return CountryLookupResult.localeUnavailable();
    }

    final String? code = _resolveLocale(locale);
    if (code == null) {
      return CountryLookupResult.localeUnavailable();
    }

    final data = codes[code];
    if (data == null) {
      return CountryLookupResult.countryNotSupported(resolvedAlpha2: code);
    }

    return CountryLookupResult.success(
      details: CountryDetails.fromMap(data, _localizedCountryNames[code]),
      resolvedAlpha2: code,
    );
  }

  /// Returns the `CountryDetails` for the given [locale]. If details cannot be
  /// resolved, throws a [StateError]. Use [detailsForLocaleOrNull] for null-safe
  /// lookup.
  static CountryDetails detailsForLocale([Locale? locale]) {
    final details = detailsForLocaleOrNull(locale);
    if (details == null) {
      throw StateError(
        'Unable to resolve country details for locale: $locale. '
        'Call init() first or provide a valid locale with region.',
      );
    }
    return details;
  }

  /// Returns the `CountryDetails` for the given country alpha2 code.
  static CountryDetails detailsFromAlpha2(String alpha2) {
    final normalized = alpha2.trim().toUpperCase();
    final data = codes[normalized];
    if (data == null) {
      throw ArgumentError.value(
        alpha2,
        'alpha2',
        'Unknown ISO 3166-1 alpha-2 code.',
      );
    }
    return CountryDetails.fromMap(data, _localizedCountryNames[normalized]);
  }

  /// Returns the ISO 3166-1 `alpha2Code` for the given [locale].
  /// If not provided, device's locale will be used instead.
  /// You can read more about ISO 3166-1 codes [here](https://en.wikipedia.org/wiki/ISO_3166-1)
  ///
  /// Example: (`US`, `PT`, etc.)
  static String? alpha2Code([Locale? locale]) {
    return detailsForLocaleOrNull(locale)?.alpha2Code;
  }

  /// Returns the `dialCode` for the given [locale] or device's locale, if not provided.
  ///
  /// Example: (`+1`, `+351`, etc.)
  static String? dialCode([Locale? locale]) {
    return detailsForLocaleOrNull(locale)?.dialCode;
  }

  /// Returns the exended `name` for the given [locale] or if not provided, device's locale.
  ///
  /// Example: (`United States`, `Portugal`, etc.)
  static String? name({Locale? locale, VoidCallback? onInvalidLocale}) {
    final details = detailsForLocaleOrNull(locale);
    if (details == null) {
      if (onInvalidLocale != null) {
        onInvalidLocale();
      }
      return null;
    }
    return details.name;
  }
}
