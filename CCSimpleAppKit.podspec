#
#  Be sure to run `pod spec lint CCSimpleAppKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "CCSimpleAppKit"
  s.version      = "0.0.1"
  s.summary      = "CCSimpleAppKit promote develop efficient."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
TODO: Add long description of the pod here.
                   DESC

  s.homepage     = "https://github.com/libing0924/CCSimpleAppKit"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.platform     = :ios, '8.0'
  s.author           = { 'libing0924' => '404044359@qq.com' }
  s.source           = { :git => 'https://github.com/libing0924/CCSimpleAppKit.git', :tag => "#{s.version}" }

  s.ios.deployment_target = '8.0'

  s.source_files = 'CCSimpleAppKit/MassiveKit/*.{h,m}','CCSimpleAppKit/MassiveKit/**/*.{h,m}'
  s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'MJRefresh'
    

end
