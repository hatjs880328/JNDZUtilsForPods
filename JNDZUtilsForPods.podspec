

Pod::Spec.new do |s|

  s.name         = 'JNDZUtilsForPods'

  s.version      = '0.0.2'

  s.summary      = 'Aof JNDZUtilsForPods.'

  s.homepage     = 'https://github.com/hatjs880328/JNDZUtilsForPods'

  s.license      = 'MIT'

  s.author       = { 'JDDZMergeSort Software Foundation' => 'shanwz@jndzkj.net' }

  s.source       = { :git => 'https://github.com/hatjs880328/JNDZUtilsForPods.git', :tag => s.version }

  s.source_files = 'Source/**/*'

  s.ios.deployment_target = '8.0'

  s.description = <<-DESC
                    CAN'T BELIEVE THE DESC SUCH IMPORT??????
                    DESC

  s.frameworks = 'Foundation','UIKit'
  
  s.dependencies = {

  'SnapKit' => ['3.0.2'],

  'CryptoSwift' => ['0.6.7']

  }               

end
