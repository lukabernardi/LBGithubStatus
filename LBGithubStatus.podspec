Pod::Spec.new do |s|
  s.name         = "LBGithubStatus"
  s.version      = "0.2.0"
  s.summary      = "An Objective-C wrapper for GitHub Status API based on AFNetworking."
  s.homepage     = "https://github.com/lukabernardi/LBGithubStatus"
  s.license      = { :type => 'MIT',
                     :file => 'LICENSE' }
  s.author       = { "Luca Bernardi" => "luka.bernardi@gmail.com" }
  s.source       = { :git => "https://github.com/lukabernardi/LBGithubStatus.git", :tag => "0.2.0" }

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.7'

  s.source_files = 'Classes', 'LBGithubStatus/LBGithubStatus*.{h,m}'
  s.requires_arc = true

  s.dependency 'AFNetworking', '~> 2.1.0'
  s.dependency 'ISO8601DateFormatter', '~> 0.6'
end
