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

#if DEBUG
import FLEX
#endif


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
    }
    
}

extension LibsManager {
    
    // 日志设置
    private func _setupCocoaLumberjack() {
        DDLog.add(DDOSLogger.sharedInstance)
        
        // 文件储存
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7 // max number files
        DDLog.add(fileLogger)
    }
}
