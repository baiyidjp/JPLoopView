

Pod::Spec.new do |s|

  s.name         = "JPLoopView"
  s.version      = "1.0.3"
  s.summary      = "Loop view."
  s.homepage     = "https://github.com/baiyidjp/JPLoopView"
  s.license      = "MIT"
  s.author             =  "baiyi"
  s.ios.deployment_target = "9.0"
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.source       = { :git => "https://github.com/baiyidjp/JPLoopView.git", :tag => "#{s.version}" }
  s.source_files  = "JPLoopView/*.{h,m}"
  s.requires_arc = true
  s.dependency "SDWebImage"
  s.dependency 'JPUtils-OC/Timer'
# pod trunk push --allow-warnings
end
