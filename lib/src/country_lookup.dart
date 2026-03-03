import 'package:country_codes_plus/src/country_details.dart';

/// Status of a country lookup attempt.
enum CountryLookupStatus {
  success,
  localeUnavailable,
  countryNotSupported,
}

/// Result object for locale-to-country resolution.
class CountryLookupResult {
  final CountryLookupStatus status;
  final CountryDetails? details;
  final String? resolvedAlpha2;

  const CountryLookupResult._({
    required this.status,
    this.details,
    this.resolvedAlpha2,
  });

  factory CountryLookupResult.success({
    required CountryDetails details,
    required String resolvedAlpha2,
  }) {
    return CountryLookupResult._(
      status: CountryLookupStatus.success,
      details: details,
      resolvedAlpha2: resolvedAlpha2,
    );
  }

  factory CountryLookupResult.localeUnavailable() {
    return const CountryLookupResult._(
      status: CountryLookupStatus.localeUnavailable,
    );
  }

  factory CountryLookupResult.countryNotSupported({String? resolvedAlpha2}) {
    return CountryLookupResult._(
      status: CountryLookupStatus.countryNotSupported,
      resolvedAlpha2: resolvedAlpha2,
    );
  }

  bool get isSuccess => status == CountryLookupStatus.success;
}
