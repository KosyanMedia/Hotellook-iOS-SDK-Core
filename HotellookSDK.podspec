Pod::Spec.new do |s|
  s.name         = 'HotellookSDK'
  s.version      = '1.0.7'
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/KosyanMedia/Hotellook-iOS-SDK-Core'
  s.authors      = { 'Hotellook iOS Team' => 'support@aviasales.ru' }
  s.summary      = 'Integrate hotels search framework in your apps.'
  s.source       = { :git => 'https://github.com/KosyanMedia/Hotellook-iOS-SDK-Core.git', :tag => "v1.0.7" }
  s.platform     = :ios, '9.0'
  s.source_files  = ["Sources/**/*.{swift,h,m}", "SupportFiles/HotellookSDK.h"]
  s.module_map  = 'SupportFiles/HotellookSDK.modulemap'
  s.swift_version = '4.2'
  s.dependency 'Alamofire', '~> 4.7'
  s.dependency 'SwiftProtobuf', '~> 1.0.3'
  s.dependency 'KeychainSwift', '~> 8.0'
end
