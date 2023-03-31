ios_sdk_version = 'Unknown'

config = File.expand_path(File.join('..', '..', 'version.config'), __FILE__)

File.foreach(config) do |line|
    matches = line.match(/ios_call_sdk_version\=(.*)/)
    if matches
      ios_sdk_version = matches[1].split("#")[0].strip
    end
end

if ios_sdk_version == 'Unknown'
    raise "You need to config ios_sdk_version in version.config!!"
end

Pod::Spec.new do |s|
  s.name             = 'rongcloud_call_wrapper_plugin'
  s.version          = '0.0.1'
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

  s.vendored_frameworks = ['Frameworks/*.xcframework','Frameworks/*.framework']

  s.dependency 'RongCloudRTC/RongCallLib', ios_sdk_version

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
