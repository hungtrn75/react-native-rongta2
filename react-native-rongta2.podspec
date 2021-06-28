# react-native-rongta2.podspec

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-rongta2"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-rongta2
                   DESC
  s.homepage     = "https://github.com/github_account/react-native-rongta2"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Your Name" => "yourname@email.com" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/github_account/react-native-rongta2.git", :tag => "#{s.version}" }

  s.source_files = 'ios/Classes/**/*'
  s.public_header_files = 'ios/Classes/**/*.h'
  s.requires_arc = true

  s.vendored_libraries = 'ios/libRTPrinterSDK.a'

  s.preserve_paths = 'CoreBluetooth.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework CoreBluetooth' }
  s.vendored_frameworks = 'CoreBluetooth.framework'


  s.default_subspec = 'RongTa_Core'
  s.subspec 'RongTa_Core' do |core|
    core.source_files = 'ios/RTPrinterSDK/*.{h,m}'
  end

  s.dependency "React"
  # ...
  # s.dependency "..."
end

