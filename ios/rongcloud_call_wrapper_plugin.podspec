#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_calllib_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'rongcloud_call_wrapper_plugin'
  s.version          = '5.1.15'
  s.summary          = 'Rongcloud calllib interface wrapper for flutter.'
  s.description      = <<-DESC
Rongcloud calllib interface wrapper for flutter.
                       DESC
  s.homepage         = 'https://www.rongcloud.cn/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rongcloud' => 'songhfmail@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.vendored_frameworks = 'Frameworks/*.xcframework'
  #s.resource = ['Frameworks/*.bundle']

  s.dependency 'RongCloudIM/IMLib', '5.1.6'
  s.dependency 'RongCloudRTC/RongCallLib', '5.1.15'
  s.dependency 'RongCloudRTC/RongFaceBeautifier', '5.1.15'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
