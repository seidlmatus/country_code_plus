/// Web registration for `country_codes_plus`.
///
/// Locale detection is implemented in the shared Dart API using Flutter's
/// `PlatformDispatcher`; this registration class keeps plugin discovery valid
/// on Web without relying on deprecated `dart:html`.
class CountryCodesWebPlugin {
  /// Registers the web implementation with Flutter's plugin registrar.
  static void registerWith(Object registrar) {}
}
