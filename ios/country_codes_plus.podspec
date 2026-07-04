#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint country_codes_plus.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'country_codes_plus'
  s.version          = '0.0.1'
  s.summary          = 'Country and locale details for Flutter applications.'
  s.description      = <<-DESC
Provides country names, ISO codes, dial codes, locale lookup, and subdivisions.
                       DESC
  s.homepage         = 'https://github.com/seidlmatus/country_code_plus'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Matus Seidl'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
