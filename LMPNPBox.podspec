Pod::Spec.new do |s|

  s.name             = 'LMPNPBox'
  s.version          = '0.1.0'
  s.summary          = 'LMPNPBox.'
  s.description      = <<-DESC
                        TODO: Plug and pull fast communication box， Nim Tim aliyunMQTT integration is provided，LMPNPBOX ADAPTS multiple communication modes to one library
                       DESC
  s.homepage         = 'https://github.com/SSLiam/LMPNPBox'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Liam Lincoln' => 'brickerdev@163.com' }
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"

  s.source           = { :git => 'git@github.com:SSLiam/LMPNPBox.git', :tag => "#{s.version}" }
  
  s.swift_version = '5.0'
  s.static_framework = true
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
      core.source_files = "LMPNPBox/**/*.{swift}",
                          "LMPNPBox/Classes/LMPNPBox.h",
                          "LMPNPBox/**/*-swift.{swift}"
      core.frameworks = "Foundation","UIKit"
      core.dependency 'MQTTClient', '~> 0.15.3'
      core.dependency 'TXIMSDK_iOS', '~> 4.4.900'
      core.dependency 'NIMSDK_LITE', '~> 4.2.0'
  end
  
  s.subspec 'Base' do |base|
    base.source_files = "LMPNPBox/Classes/base/*.swift",
                        "LMPNPBox/Classes/config/*.swift",
                        "LMPNPBox/Classes/protocols/*.swift",
                        "LMPNPBox/Classes/LMPNPBox.h",
                        "LMPNPBox/Classes/LMPNPIMBoxClient.swift"
    base.frameworks = "Foundation","UIKit"
    base.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES'}
  end

  s.subspec 'AliyunMQTT' do |aliyun_mqtt|
    aliyun_mqtt.source_files = "LMPNPBox/Classes/AliyunMQTT/*.swift",
                               "LMPNPBox/Classes/LMPNPIMBoxClient+Aliyun.swift"
    aliyun_mqtt.xcconfig = { "HEADER_SEARCH_PATHS" => "${PODS_CONFIGURATION_BUILD_DIR}/MQTTClient" }
    aliyun_mqtt.dependency 'LMPNPBox/Base'
    aliyun_mqtt.dependency 'MQTTClient', '~> 0.15.3'
  end

  s.subspec 'TIM' do |tim|
    tim.source_files = "LMPNPBox/Classes/TIM/*.swift",
                       "LMPNPBox/Classes/LMPNPIMBoxClient+TIM.swift"
    tim.xcconfig = { "HEADER_SEARCH_PATHS" => "${PODS_ROOT}/TXIMSDK_iOS" }
    tim.dependency 'LMPNPBox/Base'
    tim.dependency 'TXIMSDK_iOS', '~> 4.4.900'
  end

  s.subspec 'NIM' do |nim|
    nim.source_files = "LMPNPBox/Classes/NIM/*.swift",
                       "LMPNPBox/Classes/LMPNPIMBoxClient+NIM.swift"
    nim.xcconfig = { "HEADER_SEARCH_PATHS" => "${PODS_ROOT}/NIMSDK_LITE/NIMSDK" }
    nim.dependency 'LMPNPBox/Base'
    nim.dependency 'NIMSDK_LITE', '~> 4.2.0'
  end

end


