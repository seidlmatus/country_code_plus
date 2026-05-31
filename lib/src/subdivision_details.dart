class CountrySubdivision {
  /// ISO 3166-2 code
  /// Example: `SK-BL`, `CZ-10`
  final String code;

  /// ISO 3166-1 alpha-2 country code
  /// Example: `SK`, `CZ`
  final String countryAlpha2Code;

  /// Subdivision name
  /// Example: `Bratislavsky kraj`, `Hlavni mesto Praha`
  final String name;

  /// Subdivision type from ISO 3166-2
  /// Example: `Region`, `State`, `Parish`
  final String? type;

  const CountrySubdivision({
    required this.code,
    required this.countryAlpha2Code,
    required this.name,
    this.type,
  });

  factory CountrySubdivision.fromMap(Map<String, String> data) {
    return CountrySubdivision(
      code: data['code']!,
      countryAlpha2Code: data['countryAlpha2Code']!,
      name: data['name']!,
      type: data['type'],
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CountrySubdivision &&
            other.code == code &&
            other.countryAlpha2Code == countryAlpha2Code &&
            other.name == name &&
            other.type == type;
  }

  @override
  int get hashCode => Object.hash(code, countryAlpha2Code, name, type);

  @override
  String toString() {
    return 'CountrySubdivision('
        'code: $code, '
        'countryAlpha2Code: $countryAlpha2Code, '
        'name: $name, '
        'type: $type'
        ')';
  }
}
