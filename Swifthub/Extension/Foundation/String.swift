//
//  String.swift
//  Swifthub
//
//  Created by apple on 2023/12/29.
//

import Foundation
import Localize_Swift

extension StaticString {
    
    func localized() -> String {
        return description.localized()
    }
    
    
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return description.localizedFormat(arguments)
    }
}
