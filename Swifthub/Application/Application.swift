//
//  Application.swift
//  Swifthub
//
//  Created by apple on 2023/12/28.
//

import UIKit

final class Application: NSObject {
    
    static let shared = Application()
    
    var window: UIWindow?
    let navigator: Navigator

    
    private override init() {
        navigator = Navigator.default
        super.init()
    }
    
    
    func presentInitialScreen(in window: UIWindow?) {
        guard let window = window else { return }
        self.window = window
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.navigator.show(segue: .tabs, sender: nil, transition: .root(in: window))
        }
    }
    
    
    func presentTestScreen(in window: UIWindow?) {
//        guard let window = window, let provider = provider else { return }
//        let viewModel = UserViewModel(user: User(), provider: provider)
//        navigator.show(segue: .userDetails(viewModel: viewModel), sender: nil, transition: .root(in: window))
    }
}
