import 'package:country_codes_plus/country_codes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('legacy entrypoint exports subdivision type', () {
    final List<CountrySubdivision> subdivisions =
        CountryCodes.subdivisionsForCountry('SK');

    expect(subdivisions, isNotEmpty);
    expect(subdivisions.first.countryAlpha2Code, 'SK');
  });
}
