//
//  FakeAnalyticsTracker.swift
//  Sample Feature
//

import Foundation
import AnalyticsInterfaces

@testable import SampleFeature

final class FakeAnalyticsTracker: AnalyticsTracker {
    func track(event: AnalyticsEvent) {}

    func start(timedEvent: AnalyticsEvent) {}

    func stop(timedEvent: AnalyticsEvent) {}

    func trackFirstInstallation() {}
}
