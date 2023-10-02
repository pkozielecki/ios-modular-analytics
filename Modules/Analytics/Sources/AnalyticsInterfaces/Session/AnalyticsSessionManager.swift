//
//  AnalyticsSessionManager.swift
//  Analytics
//

import Foundation

public protocol AnalyticsSessionManager: AnyObject {
    func start(session: AnalyticsSession)
}
