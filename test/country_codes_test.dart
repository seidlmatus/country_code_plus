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
  });
}
