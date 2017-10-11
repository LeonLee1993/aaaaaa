Pod::Spec.new do |s|
  s.name         = "LYCtestDemo"
  s.version      = '0.0.4'
  s.summary      = 'An easy way to use pull-to-refresh'
  s.homepage     = 'https://github.com/LeonLee1993/anotherTestDemo'
  s.license      = 'MIT'
  s.author       = {'niolgowoma1993.' => '592979364@qq.com'}
  s.platform     = :ios, '11.0'
  s.source       = {:git => 'https://github.com/LeonLee1993/anotherTestDemo.git', :tag => s.version}
  s.source_files  = 'try2/testViews/*.{h,m}'
  s.vendored_frameworks = 'try2/aframework.framework'
  s.dependency "MBProgressHUD","1.0.0"
end
