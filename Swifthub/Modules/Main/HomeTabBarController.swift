//
//  ViewController.swift
//  Swifthub
//
//  Created by apple on 2023/12/28.
//

import UIKit

public class HomeTabBarController: UITabBarController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.theme.backgroundColor = themeService.attribute{ $0.secondary }


    }


}

