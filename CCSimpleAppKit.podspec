
Pod::Spec.new do |s|

  s.name         = "CCSimpleAppKit"
  s.version      = "1.0.1"
  s.summary      = "CCSimpleAppKit promote develop efficient."

  s.description  = <<-DESC
TODO: Add long description of the pod here.
                   DESC

  s.homepage     = "https://github.com/libing0924/CCSimpleAppKit"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.platform     = :ios, '8.0'
  s.author           = { 'libing0924' => '404044359@qq.com' }
  s.source           = { :git => 'https://github.com/libing0924/CCSimpleAppKit.git', :tag => "#{s.version}" }

  s.ios.deployment_target = '8.0'

  s.source_files = 'CCSimpleAppKit/SimpleKit/*.{h,m}','CCSimpleAppKit/SimpleKit/**/*.{h,m}'
  # s.dependency 'AFNetworking', '~> 2.3'
  # s.dependency 'MJRefresh'
    

end
