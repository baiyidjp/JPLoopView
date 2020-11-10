

Pod::Spec.new do |s|

  s.name         = "JPLoopView"
  s.version      = "1.0.1"
  s.summary      = "loop view."
  s.homepage     = "https://github.com/baiyidjp/JPLoopView"
  s.license      = "MIT"
  s.author             =  "baiyi"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/baiyidjp/JPLoopView.git", :tag => "#{s.version}" }
  s.source_files  = "JPLoopView/*.{h,m}"
  s.requires_arc = true
  s.dependency "SDWebImage"
# pod trunk push --allow-warnings
end
