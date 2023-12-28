//
//  Navigator.swift
//  Swifthub
//
//  Created by apple on 2023/12/28.
//

import Foundation
import Hero
import SwifterSwift
import MessageUI

protocol Navigatable {
    var navigator: Navigator! {get set}
}

// 实现了统一路由管理
class Navigator {
    
    static var `default` = Navigator()

    // MARK: - 场景列表，app 所有的场景
    enum Scene {
        case tabs
    }
    
    
    // 定义转场动画类型
    enum Transition {
        case root(in: UIWindow)
        case navigation(type: HeroDefaultAnimationType)
        case customModal(type: HeroDefaultAnimationType)
        case modal
        case detail
        case alert
        case custom
    }
    
    
    // MARK: - get a single VC
    func get (segue: Scene) -> UIViewController? {
        switch segue {
        case .tabs:
            return HomeTabBarController()
        }
    }
    
    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController()
        }
    }
    
    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    /// show
    /// - Parameters:
    ///   - segue: 显示场景，可以从场景中判断需要显示哪个控制器
    ///   - sender: sender 控制器
    ///   - transition: Transition 转场类型，根据类型判断使用哪种转场动画
    func show(segue: Scene, sender: UIViewController?, transition: Transition = .navigation(type: .cover(direction: .left))) {
        if let target = get(segue: segue) {
            _show(target: target, sender: sender, transition: transition)
        }
    }
    
    
    private func _show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root(in: let window): // window 切换
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft) {
                window.rootViewController = target
            }
            return
        case .custom: return
        default: break
        }
        
        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation or .modal transitions")
        }
        
    
        if let nav = sender as? UINavigationController {
            // push root controller on navigation stack
            nav.pushViewController(target, animated: false)
        }
        
        switch transition {
        case .navigation(let type):
            if let nav = sender.navigationController {
                // push controller to navigation stack
                nav.hero.navigationAnimationType = .autoReverse(presenting: type)
//                nav.pushViewController(target, hidesBottomBar: true, animated: true)
                nav.pushViewController(target, animated: true)
            }
        case .customModal(let type):
            // present modally with custom animation
            DispatchQueue.main.async {
                let nav = BaseNavigationController(rootViewController: target)
                nav.hero.modalAnimationType = .autoReverse(presenting: type)
                sender.present(nav, animated: true, completion: nil)
            }
        case .modal:
            // present modally
            DispatchQueue.main.async {
                let nav = BaseNavigationController(rootViewController: target)
                sender.present(nav, animated: true, completion: nil)
            }
        case .detail:
            DispatchQueue.main.async {
                let nav = BaseNavigationController(rootViewController: target)
                sender.showDetailViewController(nav, sender: nil)
            }
        case .alert:
            DispatchQueue.main.async {
                sender.present(target, animated: true, completion: nil)
            }
        default:break
        }
        
    }
    
    // 邀请联系人
//    func toInviteContact(withPhone phone: String) -> MFMessageComposeViewController {
//        let vc = MFMessageComposeViewController()
//        vc.body = "Hey! Come join SwiftHub at \(Configs.App.githubUrl)"
//        vc.recipients = [phone]
//        return vc
//    }
    
}
