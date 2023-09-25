//
//  AnalyticsTracker.swift
//  Analytics
//

import Foundation

public protocol AnalyticsTracker {
    func track(event: AnalyticsEvent)
    func start(timedEvent: AnalyticsEvent)
    func stop(timedEvent: AnalyticsEvent)
    func trackFirstInstallation()
}
