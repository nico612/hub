//
//  LogManager.swift
//  Swifthub
//
//  Created by apple on 2023/12/28.
//

import Foundation
import CocoaLumberjack
import RxSwift

public func logDebug(_ message: @autoclosure () -> DDLogMessageFormat) {
    DDLogDebug(message())
}

public func logError(_ message: @autoclosure () -> DDLogMessageFormat) {
    DDLogError(message())
}

public func logInfo(_ message: @autoclosure () -> DDLogMessageFormat) {
    DDLogInfo(message())
}

public func logVerbose(_ message: @autoclosure () -> DDLogMessageFormat) {
    DDLogVerbose(message())
}

public func logWarn(_ message: @autoclosure () -> DDLogMessageFormat) {
    DDLogWarn(message())
}

public func logResourcesCount() {
    #if DEBUG
    logDebug("RxSwift resources count: \(RxSwift.Resources.total)")
    #endif
}
