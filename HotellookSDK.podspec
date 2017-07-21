Pod::Spec.new do |s|
  s.name         = 'HotellookSDK'
  s.version      = '1.0.1'
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/KosyanMedia/Hotellook-iOS-SDK-Core'
  s.authors      = { 'Hotellook iOS Team' => 'support@aviasales.ru' }
  s.summary      = 'Integrate hotels search framework in your apps.'
  s.source       = { :git => 'https://github.com/KosyanMedia/Hotellook-iOS-SDK-Core.git', :tag => "v1.0.1" }
  s.platform     = :ios, '8.0'
  s.dependency 'Alamofire', '~> 4.4'
  s.dependency 'SwiftProtobuf'
  s.dependency 'KeychainSwift', '~> 8.0'
  s.ios.vendored_frameworks = "Library/HotellookSDK.framework"
end
