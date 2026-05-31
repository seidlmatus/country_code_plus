class CountryDetails {
  /// Dial code represents a global phone prefix for the region
  /// Example: `+1`, `+351`
  final String? dialCode;

  /// ISO 3166 alpha 2 code
  /// Example: `US`, `PT`
  final String? alpha2Code;

  /// ISO 3166 alpha 3 code
  /// Example: `USA`, `PRT`
  final String? alpha3Code;

  /// Country code
  /// Example: `en_US`
  final String? countryCode;

  /// Extended country name in its own language
  ///
  /// Examples:
  /// US : United States
  /// IT : Italia
  /// DE : Deutschland
  final String? name;

  /// Extended country name based on a region language
  ///
  /// Examples for `US`:
  /// US : United States
  /// IT : Italy
  /// DE : Germany
  final String? localizedName;

  CountryDetails.fromMap(Map<String, dynamic> data,
      [String? localizedCountryName])
      : name = data['name'],
        alpha2Code = data['alpha2Code'],
        alpha3Code = data['alpha3Code'],
        dialCode = data['dial_code'],
        countryCode = data['country_code'],
        localizedName = localizedCountryName;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CountryDetails &&
            other.dialCode == dialCode &&
            other.alpha2Code == alpha2Code &&
            other.alpha3Code == alpha3Code &&
            other.countryCode == countryCode &&
            other.name == name &&
            other.localizedName == localizedName;
  }

  @override
  int get hashCode => Object.hash(
        dialCode,
        alpha2Code,
        alpha3Code,
        countryCode,
        name,
        localizedName,
      );

  @override
  String toString() {
    return 'CountryDetails('
        'name: $name, '
        'alpha2Code: $alpha2Code, '
        'alpha3Code: $alpha3Code, '
        'dialCode: $dialCode, '
        'countryCode: $countryCode, '
        'localizedName: $localizedName'
        ')';
  }
}
