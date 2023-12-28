# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

use_frameworks!
inhibit_all_warnings!

target 'Swifthub' do
  # Pods for Swifthub
  
  # Networking
  pod 'Moya/RxSwift', '~> 15.0'  # https://github.com/Moya/Moya

  # Rx Extensions
  # RxDataSources 提供数据源的扩展，会安装 RxCocoa 和 RxRelay
  pod 'RxDataSources', '~> 5.0'  # https://github.com/RxSwiftCommunity/RxDataSources
  pod 'RxSwiftExt', '~> 6.0'  # https://github.com/RxSwiftCommunity/RxSwiftExt
  pod 'NSObject+Rx', '~> 5.0'  # https://github.com/RxSwiftCommunity/NSObject-Rx
  pod 'RxViewController', '~> 2.0'  # https://github.com/devxoul/RxViewController
  pod 'RxGesture', '~> 4.0'  # https://github.com/RxSwiftCommunity/RxGesture
  pod 'RxOptional', '~> 5.0'  # https://github.com/RxSwiftCommunity/RxOptional
  # 主题管理
  pod 'RxTheme', '~> 6.0'  # https://github.com/RxSwiftCommunity/RxTheme
  
  # JSON Mapping
  pod 'Moya-ObjectMapper/RxSwift', :git => 'https://github.com/p-rob/Moya-ObjectMapper.git', :branch => 'master'  # https://github.com/ivanbruel/Moya-ObjectMapper
  
  # Image
  pod 'Kingfisher', '~> 7.0'  # https://github.com/onevcat/Kingfisher
  
  
  # Date
  pod 'DateToolsSwift', '~> 5.0'  # https://github.com/MatthewYork/DateTools
  pod 'SwiftDate', '~> 7.0'  # https://github.com/malcommac/SwiftDate
  
  
  #Tools
  
  # 资源管理
  pod 'R.swift', '~> 7.3.2' # https://github.com/mac-cain13/R.swift
  
  # Keychain
  pod 'KeychainAccess', '~> 4.2.2' # https://github.com/kishikawakatsumi/KeychainAccess
    
    
  # UI

  pod 'SVProgressHUD', '~> 2.0'  # https://github.com/SVProgressHUD/SVProgressHUD
  pod 'ImageSlideshow/Kingfisher', :git => 'https://github.com/khoren93/ImageSlideshow.git', :branch => 'master'   # https://github.com/zvonicek/ImageSlideshow
  

  pod 'Toast-Swift', '~> 5.0.1' # https://github.com/scalessec/Toast-Swift
  
  pod 'DZNEmptyDataSet', '~> 1.0'  # https://github.com/dzenbot/DZNEmptyDataSet
  
  # 转场动画
  pod 'Hero', '~> 1.6.2' # https://github.com/lkzhao/Hero
  
  pod 'Localize-Swift', '~> 3.0'  # https://github.com/marmelroy/Localize-Swift
  
  # 动画 Tabar
  pod 'RAMAnimatedTabBarController', '~> 5.0' # https://github.com/Ramotion/animated-tab-bar
  
  # 内置多种动画、可自定义和灵活的iOS下拉刷新框架。
  pod 'KafkaRefresh', '~> 1.0' # https://github.com/OpenFeyn/KafkaRefresh
  
  # Keyboard
  pod 'IQKeyboardManagerSwift', '~> 6.0'  # https://github.com/hackiftekhar/IQKeyboardManager
  
  
  # 异步框架
  pod 'PromiseKit', '~> 8.1.1' # https://github.com/mxcl/PromiseKit
  
  # 初始化语法糖
  pod 'Then', '~> 3.0.0' # https://github.com/devxoul/Then
  
  
  # Auto Layout
  pod 'SnapKit', '~> 5.6.0' # https://github.com/SnapKit/SnapKit
  
  # Code Quality
  
  # 一系列扩展和工具
  pod 'SwifterSwift' # https://github.com/SwifterSwift/SwifterSwift
  pod 'FLEX', '~> 5.0', :configurations => ['Debug']  # https://github.com/Flipboard/FLEX
  pod 'BonMot', '~> 6.0'  # https://github.com/Rightpoint/BonMot

  # Logging
  pod 'CocoaLumberjack/Swift', '~> 3.0'  # https://github.com/CocoaLumberjack/CocoaLumberjack

end


post_install do |installer|
    # Cocoapods optimization, always clean project after pod updating
    Dir.glob(installer.sandbox.target_support_files_root + "Pods-*/*.sh").each do |script|
        flag_name = File.basename(script, ".sh") + "-Installation-Flag"
        folder = "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
        file = File.join(folder, flag_name)
        content = File.read(script)
        content.gsub!(/set -e/, "set -e\nKG_FILE=\"#{file}\"\nif [ -f \"$KG_FILE\" ]; then exit 0; fi\nmkdir -p \"#{folder}\"\ntouch \"$KG_FILE\"")
        File.write(script, content)
    end
    
    # Enable tracing resources
    installer.pods_project.targets.each do |target|
      if target.name == 'RxSwift'
        target.build_configurations.each do |config|
          if config.name == 'Debug'
            config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
          end
        end
      end
    end
    
    # To hide deployment target warnings
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
end
