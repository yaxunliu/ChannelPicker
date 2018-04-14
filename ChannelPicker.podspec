
Pod::Spec.new do |s|
  s.name             = 'ChannelPicker'
  s.version          = '0.1.0'
  s.summary          = 'channel picker controller'

  s.description      = '用来做频道选择的控制器，可以很方便的订制'

  s.homepage         = 'https://github.com/yaxunliu/ChannelPicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuyaxun' => '1175222300@qq.com' }
  s.source           = { :git => 'https://github.com/liuyaxun/ChannelPicker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'ChannelPicker/Classes/**/*'

end
