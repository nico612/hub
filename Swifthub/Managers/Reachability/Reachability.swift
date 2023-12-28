//
//  Reachability.swift
//  Swifthub
//
//  Created by apple on 2023/12/29.
//

import Foundation
import RxSwift
import Alamofire

func connectedToInternet() -> Observable<Bool> {
    return ReachabilityManager.shared.reach
}


private class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()
    
    // 缓存网络是否可达，，接收并缓存发送给它的所有事件，然后在有新的订阅者时将这些事件重新发送给新的订阅者。
    let reachSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    
    var reach: Observable<Bool> {
        return reachSubject.asObserver()
    }
    
    override init() {
        super.init()
        
        // 监听网络状态
        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { status in
            switch status {
            case .notReachable:
                self.reachSubject.onNext(false)
            case .reachable:
                self.reachSubject.onNext(true)
            case .unknown:
                self.reachSubject.onNext(false)
            }
        })
    }
    
}
