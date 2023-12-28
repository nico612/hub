//
//  AppDelegate.swift
//  Swifthub
//
//  Created by apple on 2023/12/28.
//

import UIKit
import Toast_Swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// app 库相关设置
        let libManager = LibsManager.shared
        libManager.setupLibs()
        
        // 订阅网络状态，当网络发生改变时显示的提示消息
        connectedToInternet().skip(1).subscribe { [weak self] connected in
            
            var style = ToastManager.shared.style
            style.backgroundColor = connected ? UIColor.Material.green: UIColor.Material.red
            let message = connected ? R.string.localizable.toastConnectionBackMessage.key.localized(): R.string.localizable.toastConnectionLostMessage.key.localized()
            let image = connected ? R.image.icon_toast_success(): R.image.icon_toast_warning()
            if let view = self?.window?.rootViewController?.view {
                view.makeToast(message, position: .bottom, image: image, style: style)
            }
            
        }.disposed(by: rx.disposeBag)
        
        // Override point for customization after application launch.
        Application.shared.presentInitialScreen(in: window)
        
        
        
        return true
    }

}

