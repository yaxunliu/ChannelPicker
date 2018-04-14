
Pod::Spec.new do |s|
  s.name             = 'ChannelPicker'
  s.version          = '0.1.1'
  s.summary          = 'channel picker controller'

  s.description      = 'channel picker controller 用来做频道选择的控制器，可以很方便的订制,可以通过进行分区设置'

  s.homepage         = 'https://github.com/yaxunliu/ChannelPicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuyaxun' => '1175222300@qq.com' }
  s.source           = { :git => 'https://github.com/yaxunliu/ChannelPicker.git', :tag => s.version.to_s }

  s.resources = ["Classes/YXChannelCell.xib", "Classes/YXChannelHeader.xib"]


  s.ios.deployment_target = '8.0'
  s.source_files = 'ChannelPicker/Classes/**/*'

end
