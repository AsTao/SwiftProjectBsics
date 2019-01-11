#
# Be sure to run `pod lib lint SwiftProjectBsics.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#B

Pod::Spec.new do |s|
  s.name             = 'SwiftProjectBsics'
  s.version          = '0.6.5'
  s.summary          = 'A short description of SwiftProjectBsics.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/AsTao/SwiftProjectBsics'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ssTaoz' => '236048180@qq.com' }
  s.source           = { :git => 'https://github.com/AsTao/SwiftProjectBsics.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.resources = 'SwiftProjectBsics/Assets/SwiftResource.bundle'
  s.source_files = 'SwiftProjectBsics/Http/*','SwiftProjectBsics/Common/*','SwiftProjectBsics/Extentions/*' ,'SwiftProjectBsics/Base/*'
  
  s.frameworks = 'UIKit', 'Foundation' , 'CoreGraphics'
  s.dependency 'Alamofire'
  s.dependency 'CryptoSwift'
  s.dependency 'MJRefresh'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }# 'SWIFT_INCLUDE_PATHS' => '${SRCROOT}/../../SwiftProjectBsics/IPhoneos'
  s.swift_version = '4.2'

end
