mv example/lib/main-publish.dart example/lib/main.dart
  rm -rf example/lib/data
  rm -rf example/lib/frame
  rm -rf example/lib/module
  rm -rf example/lib/router
  rm -rf example/lib/utils
  rm -rf example/lib/widgets
  rm -rf example/lib/global_config.dart
  rm example/ios/archive.plist
  rm jenkins.sh
  rm release.sh
  rm github.sh
  sh version.sh
  rm version.sh