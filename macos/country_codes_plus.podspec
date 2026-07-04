#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint country_codes_plus.podspec` to validate before publishing.
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
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
