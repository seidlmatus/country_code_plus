import 'package:country_codes_plus/country_codes_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A formatter that dynamically adds the `dialCode` for the given [locale] as a prefix of the input text.
/// When not provided, the device's locale will be used instead.
/// This can be handy to use along with `TextFormFields` that are typically used on phone numbers forms.
class DialCodeFormatter extends TextInputFormatter {
  final Locale? locale;
  final String separator;
  final bool preserveExistingInternationalPrefix;

  DialCodeFormatter([
    this.locale,
    this.separator = '',
    this.preserveExistingInternationalPrefix = true,
  ]);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String? code = CountryCodes.dialCode(locale);
    if (code == null || code.isEmpty) {
      return newValue;
    }

    if (newValue.text.startsWith(code)) {
      return newValue;
    }

    if (preserveExistingInternationalPrefix && newValue.text.startsWith('+')) {
      return newValue;
    }

    final String text = newValue.text.contains('+') ? '' : newValue.text;
    final String joiner = text.isNotEmpty ? separator : '';
    final String nextValue = '$code$joiner$text';
    return TextEditingValue(
      text: nextValue,
      selection: TextSelection.collapsed(offset: nextValue.length),
    );
  }
}
