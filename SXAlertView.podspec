Pod::Spec.new do |s|
s.name     = 'SXAlertView'
s.version  = '2.1'
s.license  = { :type => 'MIT', :file => 'LICENSE'}
s.summary  = '600行代码实现的简易UIAlertView，添加动画，虚化效果。接口文件中没有对视图的更多的视图属性开放接口，使用过程中可以根据自己的需求进行自定义接口'
s.homepage = 'https://github.com/STShenZhaoliang'
s.author   = { 'STShenZhaoliang' => '409178030@qq.com' }
s.source   = {
:git => 'https://github.com/STShenZhaoliang/STAlertView.git',
:tag => s.version.to_s
}
s.ios.deployment_target = '8.0'
s.source_files = "SXAlertView/*.{h,m}"
s.requires_arc = true
end
