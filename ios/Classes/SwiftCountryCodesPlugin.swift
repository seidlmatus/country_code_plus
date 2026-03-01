import Flutter
import UIKit

public class SwiftCountryCodesPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "country_codes_plus", binaryMessenger: registrar.messenger())
    let instance = SwiftCountryCodesPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    switch call.method {
    case "getRegion":
        result(Locale.autoupdatingCurrent.regionCode)
        break
    case "getLanguage":
        result(Locale.autoupdatingCurrent.languageCode)
        break
    case "getLocale":
        result([Locale.autoupdatingCurrent.languageCode as Any, Locale.autoupdatingCurrent.regionCode as Any, getLocalizedCountryNames(localeTag: call.arguments as? String)])
        break
    default:
        result(FlutterMethodNotImplemented);
    }
  }
    
    func getLocalizedCountryNames(localeTag: String?) -> Dictionary<String,String> {
        var localizedCountries:Dictionary<String,String> = [String: String]()

        let displayLocale: Locale
        if let tag = localeTag, !tag.isEmpty {
            displayLocale = Locale(identifier: tag)
        } else {
            displayLocale = Locale.autoupdatingCurrent
        }

        for countryCode in NSLocale.isoCountryCodes {
            let countryName: String? = (displayLocale as NSLocale).displayName(forKey: .countryCode, value: countryCode)
            localizedCountries[countryCode.uppercased()] = countryName ?? ""
        }
        return localizedCountries
    }
    
 
}
