#
# Be sure to run `pod lib lint TTDownloadCache.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TTDownloadCache'
  s.version          = '0.1.0'
  s.summary          = 'A download caching library example'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A download cache library project for a demonstration of capabilities. The download library has zero dependencies, itself. Should run on everything 7.x and upwards. It exposes a very simple interface to download any kind of resource, and vends an NSData object in return.
                       DESC

  s.homepage         = 'https://github.com/dhiraj/TTDownloadCache'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dhiraj Gupta' => 'dhiraj@traversient.com' }
  s.source           = { :git => 'https://github.com/dhiraj/TTDownloadCache.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dhiraj'

  s.ios.deployment_target = '7.0'
  s.source_files = 'TTDownloadCache/Classes/**/*'

  s.public_header_files = 'TTDownloadCache/Classes/**/*.h'
end
