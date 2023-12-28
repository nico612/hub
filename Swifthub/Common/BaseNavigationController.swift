//
//  BaseNavigationController.swift
//  Swifthub
//
//  Created by apple on 2023/12/28.
//

import UIKit
import Hero

class BaseNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return globalStatusBarStyle.value
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        interactivePopGestureRecognizer?.delegate = nil // 禁用默认的 iOS 手势返回
        
        if #available(iOS 13.0, *) {
            hero.isEnabled = false
        } else {
            hero.isEnabled = true
        }
        
        // moidal 动画效果
        hero.modalAnimationType = .autoReverse(presenting: .fade)
        // 导航控制器切换效果
        hero.navigationAnimationType = .autoReverse(presenting: .slide(direction: .left))
        
        // 控制导航栏是否半透明效果
        // navigationBar.isTranslucent = false
        
        
        navigationBar.backIndicatorImage = R.image.icon_navigation_back()
        //指定导航栏返回按钮在进行导航切换时的过渡效果。通常，这个图像与 backIndicatorImage 设置的图像相同，
        navigationBar.backIndicatorTransitionMaskImage = R.image.icon_navigation_back()
        
        
        navigationBar.theme.tintColor = themeService.attribute{ $0.secondary }
        // navigationBar.theme.barTintColor = themeService.attribute { $0.primaryDark }
        navigationBar.theme.titleTextAttributes = themeService.attribute { [NSAttributedString.Key.foregroundColor: $0.text] }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
