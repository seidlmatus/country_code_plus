import 'package:country_codes_plus/country_codes_plus.dart';
import 'package:country_codes_plus/src/codes.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('codes map validation', () {
    test('keys and alpha2 codes match', () {
      for (final entry in codes.entries) {
        final key = entry.key;
        final data = Map<String, dynamic>.from(entry.value as Map);

        expect(RegExp(r'^[A-Z]{2}$').hasMatch(key), isTrue,
            reason: 'Invalid key: $key');
        expect(data['alpha2Code'], key, reason: 'alpha2Code mismatch for $key');
      }
    });

    test('alpha3 codes are valid and unique', () {
      final seen = <String>{};

      for (final entry in codes.entries) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        final alpha3 = data['alpha3Code'] as String?;

        expect(alpha3, isNotNull,
            reason: 'Missing alpha3Code for ${entry.key}');
        expect(RegExp(r'^[A-Z]{3}$').hasMatch(alpha3!), isTrue,
            reason: 'Invalid alpha3Code for ${entry.key}');
        expect(seen.add(alpha3), isTrue,
            reason: 'Duplicate alpha3Code: $alpha3');
      }
    });

    test('dial codes are formatted with a leading plus', () {
      for (final entry in codes.entries) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        final dial = data['dial_code'] as String?;

        expect(dial, isNotNull, reason: 'Missing dial_code for ${entry.key}');
        expect(dial, dial!.trim(),
            reason: 'dial_code has surrounding whitespace for ${entry.key}');
        expect(RegExp(r'^\+[0-9 ]+$').hasMatch(dial), isTrue,
            reason: 'Invalid dial_code for ${entry.key}');
      }
    });

    test('country_code values are valid locale tags', () {
      for (final entry in codes.entries) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        final countryCode = data['country_code'] as String?;

        expect(countryCode, isNotNull,
            reason: 'Missing country_code for ${entry.key}');
        expect(RegExp(r'^[a-z]{2}_[A-Z]{2}$').hasMatch(countryCode!), isTrue,
            reason: 'Invalid country_code for ${entry.key}');
      }
    });
  });

  group('locale fallback', () {
    test('language-only locale resolves to a matching country', () {
      final details = CountryCodes.detailsForLocale(const Locale('pt'));
      expect(details.alpha2Code, 'PT');
    });

    test('english language-only locale falls back to US', () {
      final details = CountryCodes.detailsForLocale(const Locale('en'));
      expect(details.alpha2Code, 'US');
    });

    test('invalid locale returns null details in null-safe API', () {
      final details =
          CountryCodes.detailsForLocaleOrNull(const Locale('xx', 'YY'));
      expect(details, isNull);
    });
  });

  group('country list', () {
    test('includes Kosovo in countryCodes()', () {
      final allCountries = CountryCodes.countryCodes();
      final kosovo =
          allCountries.where((country) => country.alpha2Code == 'XK');

      expect(kosovo.length, 1);
      expect(kosovo.single.name, 'Kosovo');
      expect(kosovo.single.dialCode, '+383');
    });
  });

  group('lookup details result', () {
    test('returns success status for supported locale', () {
      final result = CountryCodes.lookupDetails(const Locale('sk', 'SK'));

      expect(result.status, CountryLookupStatus.success);
      expect(result.isSuccess, isTrue);
      expect(result.resolvedAlpha2, 'SK');
      expect(result.details?.dialCode, '+421');
    });

    test('returns localeUnavailable when locale cannot be resolved', () {
      final result = CountryCodes.lookupDetails();

      expect(result.status, CountryLookupStatus.localeUnavailable);
      expect(result.isSuccess, isFalse);
      expect(result.details, isNull);
    });

    test('returns countryNotSupported for unknown region', () {
      final result = CountryCodes.lookupDetails(const Locale('xx', 'YY'));

      expect(result.status, CountryLookupStatus.countryNotSupported);
      expect(result.isSuccess, isFalse);
      expect(result.resolvedAlpha2, 'YY');
      expect(result.details, isNull);
    });
  });

  group('subdivisions', () {
    test('returns all supported subdivisions', () {
      final subdivisions = CountryCodes.subdivisions();

      expect(subdivisions.length, greaterThan(5000));
      expect(subdivisions.any((entry) => entry.code == 'XK-01'), isTrue);
      expect(subdivisions.any((entry) => entry.code == 'SK-BL'), isTrue);
    });

    test('returns subdivisions for Slovakia', () {
      final subdivisions = CountryCodes.subdivisionsForCountry('sk');

      expect(subdivisions.length, 8);
      expect(subdivisions.any((entry) => entry.code == 'SK-BL'), isTrue);
      expect(subdivisions.any((entry) => entry.code == 'SK-KI'), isTrue);
    });

    test('returns subdivision details from code', () {
      final subdivision = CountryCodes.subdivisionFromCode('cz-10');

      expect(subdivision, isNotNull);
      expect(subdivision?.countryAlpha2Code, 'CZ');
      expect(subdivision?.name, 'Praha, Hlavní město');
      expect(subdivision?.type, isNotNull);
    });

    test('returns null for unknown subdivision code', () {
      final subdivision = CountryCodes.subdivisionFromCode('SK-XX');

      expect(subdivision, isNull);
    });

    test('supports subdivision lookup for all countries in codes map', () {
      final countries = CountryCodes.countryCodes();

      for (final country in countries) {
        final alpha2 = country.alpha2Code;
        expect(alpha2, isNotNull);
        expect(() => CountryCodes.subdivisionsForCountry(alpha2!),
            returnsNormally);
      }
    });

    test('searches subdivisions globally by name', () {
      final result = CountryCodes.searchSubdivisions('bratis', limit: 10);

      expect(result, isNotEmpty);
      expect(result.any((entry) => entry.code == 'SK-BL'), isTrue);
    });

    test('searches subdivisions in country scope', () {
      final result = CountryCodes.searchSubdivisions(
        'praha',
        countryAlpha2: 'CZ',
      );

      expect(result, isNotEmpty);
      expect(result.every((entry) => entry.countryAlpha2Code == 'CZ'), isTrue);
    });

    test('returns empty search results for empty query', () {
      final result = CountryCodes.searchSubdivisions('   ');
      expect(result, isEmpty);
    });

    test('returns sorted unique subdivision types for country', () {
      final types = CountryCodes.subdivisionTypesForCountry('SK');

      expect(types, isNotEmpty);
      expect(types, orderedEquals(types.toList()..sort()));
      expect(types.toSet().length, types.length);
    });
  });

  group('platform channel', () {
    const channel = MethodChannel('country_codes_plus');

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (call) async {
          if (call.method == 'getLocale') {
            return [
              'en',
              'US',
              {'US': 'United States'}
            ];
          }
          return null;
        },
      );
    });

    tearDown(() async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        null,
      );
    });

    test('init reads locale and localized names from platform', () async {
      final ok = await CountryCodes.init();
      expect(ok, isTrue);

      final locale = CountryCodes.getDeviceLocale();
      expect(locale?.languageCode, 'en');
      expect(locale?.countryCode, 'US');

      final details = CountryCodes.detailsForLocale();
      expect(details.alpha2Code, 'US');
      expect(details.localizedName, 'United States');
    });

    test('init returns false for short platform payload', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (call) async => ['en'],
      );

      final ok = await CountryCodes.init();
      expect(ok, isFalse);
    });
  });

  group('details from alpha2', () {
    test('accepts case-insensitive input', () {
      final details = CountryCodes.detailsFromAlpha2('sk');
      expect(details.alpha2Code, 'SK');
    });

    test('throws an ArgumentError with clear message for unknown code', () {
      expect(
        () => CountryCodes.detailsFromAlpha2('??'),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            contains('Unknown ISO 3166-1 alpha-2 code.'),
          ),
        ),
      );
    });
  });

  group('dial code formatter', () {
    test('does not throw when dial code cannot be resolved', () {
      final formatter = DialCodeFormatter(const Locale('xx', 'YY'));
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '123'),
      );
      expect(result.text, '123');
    });

    test('prefixes a valid dial code', () {
      final formatter = DialCodeFormatter(const Locale('sk', 'SK'));
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '123'),
      );
      expect(result.text, '+421123');
    });
  });
}
