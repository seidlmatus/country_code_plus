import 'dart:async';

import 'package:country_codes_plus/src/codes.dart';
import 'package:country_codes_plus/src/country_details.dart';
import 'package:country_codes_plus/src/country_lookup.dart';
import 'package:country_codes_plus/src/subdivision_details.dart';
import 'package:country_codes_plus/src/additional_subdivisions.dart';
import 'package:country_codes_plus/src/subdivisions.dart';
import 'package:country_codes_plus/src/sub_regions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CountryCodes {
  static const MethodChannel _channel = MethodChannel('country_codes_plus');
  static Locale? _deviceLocale;
  static Map<String, String> _localizedCountryNames = const {};

  // Platform locale data can contain version-specific translation mistakes.
  // Keep this list deliberately small and backed by current CLDR data.
  static const Map<String, Map<String, String>>
      _localizedCountryNameCorrections = {
    'sk': {'GR': 'Grécko'},
  };

  static const Map<String, String> _languageDefaults = {
    'ar': 'EG',
    'de': 'DE',
    'en': 'US',
    'es': 'ES',
    'fr': 'FR',
    'nl': 'NL',
    'pt': 'BR',
    'ru': 'RU',
  };
  static const Map<String, String> _scriptLanguageDefaults = {
    'zh_Hans': 'CN',
    'zh_Hant': 'TW',
  };

  static final Map<String, Map<String, String>> _byAlpha3 = {
    for (final entry in codes.entries) entry.value['alpha3Code']!: entry.value,
  };
  static final Map<String, List<Map<String, String>>> _byDialCode =
      _buildDialCodeIndex();

  static Map<String, List<Map<String, String>>> _buildDialCodeIndex() {
    final index = <String, List<Map<String, String>>>{};
    for (final data in codes.values) {
      final dialCode = data['dial_code'];
      if (dialCode == null) continue;
      final normalized = _normalizeDialCode(dialCode);
      (index[normalized] ??= <Map<String, String>>[]).add(data);
    }
    return {
      for (final entry in index.entries)
        entry.key: List<Map<String, String>>.unmodifiable(entry.value),
    };
  }

  static final Map<String, CountrySubdivision> _bySubdivisionCode = {
    for (final entry in subdivisionsByCode.entries)
      entry.key: CountrySubdivision.fromMap(entry.value),
    for (final entries in additionalSubdivisionsByCountry.values)
      for (final entry in entries) entry.code: entry,
  };

  static String _normalizeDialCode(String dialCode) {
    return dialCode.replaceAll(RegExp(r'\s+'), '');
  }

  static CountryDetails _detailsFromEntry(
      MapEntry<String, Map<String, String>> entry) {
    return CountryDetails.fromMap(
        entry.value, _localizedCountryNames[entry.key]);
  }

  static String? _resolveLocale(Locale? locale) {
    locale ??= _deviceLocale;
    if (locale == null) {
      assert(false, '''
         Locale cannot be null. If you are using an iOS simulator, please, make sure you go to region settings and select any country (even if it's already selected) because otherwise your country might be null.
         If you didn't provide one, please make sure you call init before using Country Details
        ''');
      return null;
    }

    String? countryCode = locale.countryCode?.toUpperCase();
    if (countryCode == null || countryCode.isEmpty) {
      countryCode =
          _countryCodeFromLanguage(locale) ?? _deviceLocale?.countryCode;
    }

    if (countryCode == null || countryCode.isEmpty) {
      return null;
    }

    if (!codes.containsKey(countryCode)) {
      countryCode = subRegionToCountryCode[countryCode] ?? countryCode;
    }

    return countryCode;
  }

  static String? _countryCodeFromLanguage(Locale locale) {
    final normalized = locale.languageCode.toLowerCase();
    final scriptDefault = locale.scriptCode == null
        ? null
        : _scriptLanguageDefaults['${normalized}_${locale.scriptCode}'];
    if (scriptDefault != null && codes.containsKey(scriptDefault)) {
      return scriptDefault;
    }
    final defaultCountry = _languageDefaults[normalized];

    if (defaultCountry != null && codes.containsKey(defaultCountry)) {
      return defaultCountry;
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
    dynamic response;
    try {
      response = await _channel.invokeMethod(
        'getLocale',
        appLocale?.toLanguageTag(),
      );
    } on MissingPluginException {
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      response = <String>[locale.languageCode, locale.countryCode ?? ''];
    }
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
      countryCode = _countryCodeFromLanguage(Locale(languageCode)) ?? '';
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

      final displayLanguage =
          (appLocale?.languageCode ?? languageCode).toLowerCase();
      final corrections = _localizedCountryNameCorrections[displayLanguage];
      if (corrections != null) {
        localizedCountryNames.addAll(corrections);
      }
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
    return codes.entries.map(_detailsFromEntry).toList();
  }

  /// A list of country data for every country.
  static List<CountryDetails> get allCountries => countryCodes();

  /// Searches countries by name, localized name, ISO codes, locale tag, or dial code.
  /// Returns at most [limit] entries (default: 20).
  static List<CountryDetails> searchCountries(String query, {int limit = 20}) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return const [];
    }

    final normalizedDialQuery = _normalizeDialCode(normalizedQuery);
    final matches = codes.entries
        .where((entry) {
          final data = entry.value;
          final localizedName =
              _localizedCountryNames[entry.key]?.toLowerCase() ?? '';
          final values = <String>[
            data['name']?.toLowerCase() ?? '',
            localizedName,
            data['alpha2Code']?.toLowerCase() ?? '',
            data['alpha3Code']?.toLowerCase() ?? '',
            data['country_code']?.toLowerCase() ?? '',
          ];

          final dialCode = data['dial_code'];
          final normalizedDialCode = dialCode == null
              ? ''
              : _normalizeDialCode(dialCode).toLowerCase();

          return values.any((value) => value.contains(normalizedQuery)) ||
              normalizedDialCode.contains(normalizedDialQuery);
        })
        .map(_detailsFromEntry)
        .toList();

    matches.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    if (limit <= 0 || matches.length <= limit) {
      return matches;
    }
    return matches.take(limit).toList();
  }

  /// Returns a list of subdivisions for the given country alpha-2 code.
  /// Codes follow ISO 3166-2 format (e.g. `SK-BL`, `CZ-10`).
  static List<CountrySubdivision> subdivisionsForCountry(String alpha2) {
    final normalizedAlpha2 = alpha2.toUpperCase();
    final entries = subdivisionsByCountry[normalizedAlpha2];
    if (entries != null) {
      return entries.map(CountrySubdivision.fromMap).toList();
    }
    return List<CountrySubdivision>.of(
      additionalSubdivisionsByCountry[normalizedAlpha2] ?? const [],
    );
  }

  static final List<CountrySubdivision> _allSubdivisions = subdivisionsByCountry
      .values
      .expand((entries) => entries)
      .map(CountrySubdivision.fromMap)
      .followedBy(
          additionalSubdivisionsByCountry.values.expand((entries) => entries))
      .toList(growable: false);

  /// Returns all available subdivisions across supported countries.
  static List<CountrySubdivision> subdivisions() {
    return List<CountrySubdivision>.of(_allSubdivisions);
  }

  /// Searches subdivisions by code, name, or type.
  /// Optionally scope the search to a single country alpha-2 code.
  /// Returns at most [limit] entries (default: 20).
  static List<CountrySubdivision> searchSubdivisions(
    String query, {
    String? countryAlpha2,
    int limit = 20,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return const [];
    }

    final source = countryAlpha2 == null
        ? _allSubdivisions
        : subdivisionsForCountry(countryAlpha2);

    final matches = source.where((entry) {
      final name = entry.name.toLowerCase();
      final code = entry.code.toLowerCase();
      final type = entry.type?.toLowerCase() ?? '';
      return name.contains(normalizedQuery) ||
          code.contains(normalizedQuery) ||
          type.contains(normalizedQuery);
    }).toList();

    matches.sort((a, b) => a.name.compareTo(b.name));
    if (limit <= 0 || matches.length <= limit) {
      return matches;
    }
    return matches.take(limit).toList();
  }

  /// Returns sorted unique subdivision types for the given country alpha-2 code.
  static List<String> subdivisionTypesForCountry(String alpha2) {
    final types = subdivisionsForCountry(alpha2)
        .map((entry) => entry.type)
        .whereType<String>()
        .map((type) => type.trim())
        .where((type) => type.isNotEmpty)
        .toSet()
        .toList();
    types.sort();
    return types;
  }

  /// Returns subdivision details for an ISO 3166-2 subdivision code.
  /// Example: `SK-BL`, `CZ-10`.
  static CountrySubdivision? subdivisionFromCode(String subdivisionCode) {
    final normalizedCode = subdivisionCode.toUpperCase();
    final details = subdivisionsByCode[normalizedCode];
    if (details == null) {
      return null;
    }

    return _bySubdivisionCode[normalizedCode];
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
    final details = detailsFromAlpha2OrNull(alpha2);
    if (details != null) return details;
    throw ArgumentError.value(
      alpha2,
      'alpha2',
      'Unknown ISO 3166-1 alpha-2 code.',
    );
  }

  /// Returns country details for [alpha2], or `null` for invalid input.
  static CountryDetails? detailsFromAlpha2OrNull(String alpha2) {
    final normalized = alpha2.trim().toUpperCase();
    final data = codes[normalized];
    return data == null
        ? null
        : CountryDetails.fromMap(data, _localizedCountryNames[normalized]);
  }

  /// Returns the `CountryDetails` for the given country alpha-3 code.
  static CountryDetails detailsFromAlpha3(String alpha3) {
    final normalized = alpha3.trim().toUpperCase();
    final data = _byAlpha3[normalized];
    if (data != null) {
      return CountryDetails.fromMap(
        data,
        _localizedCountryNames[data['alpha2Code']],
      );
    }

    throw ArgumentError.value(
      alpha3,
      'alpha3',
      'Unknown ISO 3166-1 alpha-3 code.',
    );
  }

  /// Returns country details for [alpha3], or `null` for invalid input.
  static CountryDetails? detailsFromAlpha3OrNull(String alpha3) {
    final normalized = alpha3.trim().toUpperCase();
    final data = _byAlpha3[normalized];
    return data == null
        ? null
        : CountryDetails.fromMap(
            data,
            _localizedCountryNames[data['alpha2Code']],
          );
  }

  /// Returns all countries that match the given dial code.
  ///
  /// Dial codes are not unique globally. For example, several countries share
  /// `+1`, so this method returns every exact match.
  static List<CountryDetails> countriesFromDialCode(String dialCode) {
    final normalized = _normalizeDialCode(dialCode.trim());
    if (normalized.isEmpty) {
      return const [];
    }

    return (_byDialCode[normalized] ?? const <Map<String, String>>[])
        .map((data) => CountryDetails.fromMap(
              data,
              _localizedCountryNames[data['alpha2Code']],
            ))
        .toList();
  }

  /// Returns countries matching the longest international phone prefix.
  ///
  /// Formatting characters are ignored and `+` is required. This identifies
  /// possible countries only; it does not validate a complete phone number.
  static List<CountryDetails> countriesFromPhoneNumber(String phoneNumber) {
    final normalized = phoneNumber.replaceAll(RegExp(r'[\s().-]'), '');
    if (!normalized.startsWith('+') ||
        !RegExp(r'^\+[0-9]+$').hasMatch(normalized)) {
      return const [];
    }
    final prefixes = _byDialCode.keys.where(normalized.startsWith).toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    if (prefixes.isEmpty) return const [];
    return countriesFromDialCode(prefixes.first);
  }

  /// Returns the first country that matches the given dial code, if any.
  ///
  /// Use [countriesFromDialCode] when handling shared dial codes such as `+1`.
  static CountryDetails? countryFromDialCode(String dialCode) {
    final matches = countriesFromDialCode(dialCode);
    if (matches.isEmpty) {
      return null;
    }
    return matches.first;
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

  /// Returns the extended `name` for the given [locale] or if not provided, device's locale.
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
