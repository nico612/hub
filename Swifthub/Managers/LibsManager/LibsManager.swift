//
//  LibsManager.swift
//  Swifthub
//
//  Created by apple on 2023/12/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import IQKeyboardManagerSwift
import CocoaLumberjack
import Kingfisher
import KafkaRefresh
import DropDown
import NSObject_Rx
import Toast_Swift

#if DEBUG
import FLEX
#endif


typealias DropDownView = DropDown


/// The manager class for configuring all libraries used in app.
class LibsManager: NSObject {
    
    /// the default singleton instance.
    static let shared = LibsManager()
    
    
    private override init() {
        super.init()
        
    }
    
    /// 设置libs应该在程序初始化时设置
    func setupLibs() {
        _setupCocoaLumberjack()
        _setupTheme()
        _setupKafkaRefresh()
        _setupFLEX()
        _setupKeyboardManager()
        _setupKingfisher()
        _setupDropDown()
        _setupToast()
    }
    
}

extension LibsManager {
    
    /// 绑定 statusBar 样式， 当主题改变时 statusBar样式跟着改变
    private func _setupTheme() {
        UIApplication.shared.theme.statusBarStyle = themeService.attribute { $0.statusBarStyle }
    }
    
    private func _setupKafkaRefresh() {
        
        if let defaults = KafkaRefreshDefaults.standard() {
            defaults.headDefaultStyle = .replicatorAllen
            defaults.footDefaultStyle = .replicatorDot
            defaults.theme.themeColor = themeService.attribute { $0.secondary }
        }
    }
    
    /// 调试工具
    private func _setupFLEX() {
        #if DEBUG
        FLEXManager.shared.isNetworkDebuggingEnabled = true
        #endif
    }
    
    // 日志设置
    private func _setupCocoaLumberjack() {
        DDLog.add(DDOSLogger.sharedInstance)
        
        // 文件储存
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7 // max number files
        DDLog.add(fileLogger)
    }
    
    private func _setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
    
    /// 图片加载及缓存
    private func _setupKingfisher() {
        // 设置最大图片缓存， 默认0，无限制
        ImageCache.default.diskStorage.config.sizeLimit = UInt(500 * 1024 * 1024) // 500 MB
        
        // 设置最大缓存时间，默认一周
        ImageCache.default.diskStorage.config.expiration = .days(7)
        
        // 设置图片下载器超时时间 默认 15秒
        ImageDownloader.default.downloadTimeout = 15.0 // 15 sec

    }
    
    /// 下拉菜单设置
    private func _setupDropDown() {
        themeService.typeStream.subscribe(onNext: { (themeType) in
            let theme = themeType.associatedObject
            DropDown.appearance().backgroundColor = theme.primary
            DropDown.appearance().selectionBackgroundColor = theme.primaryDark
            DropDown.appearance().textColor = theme.text
            DropDown.appearance().selectedTextColor = theme.text
            DropDown.appearance().separatorColor = theme.separator
        }).disposed(by: rx.disposeBag)
    }
    
    private func _setupToast() {
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.position = .top
        var style = ToastStyle()
        style.backgroundColor = UIColor.Material.red
        style.messageColor = UIColor.Material.white
        style.imageSize = CGSize(width: 20, height: 20)
        ToastManager.shared.style = style
    }
}
