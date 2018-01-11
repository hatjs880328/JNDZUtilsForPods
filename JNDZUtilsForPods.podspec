

Pod::Spec.new do |s|

  s.name         = 'JNDZUtilsForPods'

  s.version      = '0.0.1'

  s.summary      = 'Aof JNDZUtilsForPods.'

  s.homepage     = 'https://github.com/hatjs880328/JNDZUtilsForPods'

  s.license      = 'MIT'

  s.author       = { 'JDDZMergeSort Software Foundation' => 'shanwz@jndzkj.net' }

  s.source       = { :git => 'https://github.com/hatjs880328/JNDZUtilsForPods.git', :tag => s.version }

  #s.source_files = 'DZGCD/*.{h,m,swift,png}'

  s.subspec 'GCDUtils' do |gcdutils|
      gcdutils.source_files = 'DZGCD/*'
  #    gcdutils.public_header_files = 'Pod/Classes/CommonTools/**/*.h'
  #    gcdutils.dependency 'OpenUDID', '~> 1.0.0'
  end
 
  s.subspec 'GCDExtension' do |gcdextension|
      gcdextension.source_files = 'OriginalExtension/*'
  #    ui.public_header_files = 'Pod/Classes/UIKitAddition/**/*.h'
  #    ui.resource = "Pod/Assets/MLSUIKitResource.bundle"
  #    ui.dependency 'PodTestLibrary/CommonTools'
  end

  s.subspec 'GCDMoreTab' do |gcdmoretab|
      gcdmoretab.source_files = 'GCDMoreTab/*'
  #    ui.public_header_files = 'Pod/Classes/UIKitAddition/**/*.h'
  #    ui.resource = "Pod/Assets/MLSUIKitResource.bundle"
  #    ui.dependency 'PodTestLibrary/CommonTools'
  end

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
