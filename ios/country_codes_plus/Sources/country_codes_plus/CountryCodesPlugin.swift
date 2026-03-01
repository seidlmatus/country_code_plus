import Flutter
import Foundation
import UIKit

public class CountryCodesPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "country_codes_plus", binaryMessenger: registrar.messenger())
    let instance = CountryCodesPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getRegion":
      result(Locale.autoupdatingCurrent.regionCode)
    case "getLanguage":
      result(Locale.autoupdatingCurrent.languageCode)
    case "getLocale":
      result([
        Locale.autoupdatingCurrent.languageCode as Any,
        Locale.autoupdatingCurrent.regionCode as Any,
        getLocalizedCountryNames(localeTag: call.arguments as? String),
      ])
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func getLocalizedCountryNames(localeTag: String?) -> [String: String] {
    var localizedCountries: [String: String] = [:]

    let displayLocale: Locale
    if let tag = localeTag, !tag.isEmpty {
      displayLocale = Locale(identifier: tag)
    } else {
      displayLocale = Locale.autoupdatingCurrent
    }

    for countryCode in NSLocale.isoCountryCodes {
      let countryName = (displayLocale as NSLocale).displayName(forKey: .countryCode, value: countryCode)
      localizedCountries[countryCode.uppercased()] = countryName ?? ""
    }
    return localizedCountries
  }
}
