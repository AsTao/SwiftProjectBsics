#
# Be sure to run `pod lib lint SwiftProjectBsics.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftProjectBsics'
  s.version          = '0.8.4'
  s.summary          = '公共组件，网络请求，常量，便捷函数，通过Cocoapods集成'


  s.homepage         = 'https://github.com/AsTao/SwiftProjectBsics'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tao' => '236048180@qq.com' }
  s.source           = { :git => 'https://github.com/AsTao/SwiftProjectBsics.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'SwiftProjectBsics/Classes/**/*'
  s.frameworks = 'UIKit', 'Foundation' , 'CoreGraphics'

  
  s.dependency 'Kingfisher'
  s.dependency 'Alamofire' 
  s.dependency 'MJRefresh'
  s.dependency 'MMKV'
end
