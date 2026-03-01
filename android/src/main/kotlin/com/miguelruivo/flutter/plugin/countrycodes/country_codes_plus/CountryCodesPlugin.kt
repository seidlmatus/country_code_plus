package com.miguelruivo.flutter.plugin.countrycodes.country_codes_plus

import android.content.Context
import android.os.Build
import java.util.Locale
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** CountryCodesPlugin */
public class CountryCodesPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var applicationContext: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "country_codes_plus")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    when (call.method) {
        "getLocale" -> {
          val locale = resolveLocale()
          result.success(listOf(locale.language, locale.country, getLocalizedCountryNames(call.arguments as String?)))
        }
        "getRegion" -> result.success(resolveLocale().country)
        "getLanguage" -> result.success(resolveLocale().language)
        else -> result.notImplemented()
    }
  }

  private fun getLocalizedCountryNames(localeTag: String?) : HashMap<String, String> {
    val localizedCountries: HashMap<String,String> = HashMap()
    val displayLocale = resolveDisplayLocale(localeTag)

    for (countryCode in Locale.getISOCountries()) {
      val locale = Locale("", countryCode)
      val countryName: String? = locale.getDisplayCountry(displayLocale)
      localizedCountries[countryCode.uppercase()] = countryName ?: ""
    }
    return localizedCountries
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun resolveDisplayLocale(localeTag: String?): Locale {
    if (!localeTag.isNullOrBlank()) {
      return Locale.forLanguageTag(localeTag)
    }
    return resolveLocale()
  }

  private fun resolveLocale(): Locale {
    val config = applicationContext.resources.configuration
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      val locales = config.locales
      for (i in 0 until locales.size()) {
        val locale = locales[i]
        if (locale != null && locale.country.isNotEmpty()) {
          return locale
        }
      }
      if (locales.size() > 0) {
        return locales[0]
      }
    } else {
      @Suppress("DEPRECATION")
      return config.locale ?: Locale.getDefault()
    }

    return Locale.getDefault()
  }
}
