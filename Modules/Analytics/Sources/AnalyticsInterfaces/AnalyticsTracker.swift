//
//  AnalyticsTracker.swift
//  Analytics
//

import Foundation

public protocol AnalyticsTracker: AnyObject {
    func track(event: AnalyticsEvent)
    func start(timedEvent: AnalyticsEvent)
    func stop(timedEvent: AnalyticsEvent)
    func trackFirstInstallation()
}
