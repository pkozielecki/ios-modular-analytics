//
//  FirebaseAnalyticsClient.swift
//  Analytics
//

import Foundation
import FirebaseAnalytics
import AnalyticsInterfaces
import StorageInterfaces

public final class FirebaseAnalyticsClient: AnalyticsClient {
    private let storage: SimpleStorage
    private let analyticsWrapper: FirebaseAnalyticsWrapper.Type

    public init(
        storage: SimpleStorage,
        analyticsWrapper: FirebaseAnalyticsWrapper.Type = Analytics.self
    ) {
        self.storage = storage
        self.analyticsWrapper = analyticsWrapper
    }

    public func track(event: AnalyticsEvent) {
        analyticsWrapper.logEvent(event.analyticsName, parameters: event.context)
    }

    public func start(timedEvent: AnalyticsEvent) {
        let name = composeTimedEventName(event: timedEvent, isStarting: true)
        analyticsWrapper.logEvent(name, parameters: timedEvent.context)
    }

    public func stop(timedEvent: AnalyticsEvent) {
        let name = composeTimedEventName(event: timedEvent, isStarting: false)
        analyticsWrapper.logEvent(name, parameters: timedEvent.context)
    }

    public func start(session: AnalyticsSession) {
        switch session {
        case .unauthenticated:
            setSessionParameters(analyticsUser: nil)
        case let .authenticated(analyticsUser):
            setSessionParameters(analyticsUser: analyticsUser)
        }
    }

    public func trackFirstInstallation() {
        analyticsWrapper.logEvent(AnalyticsEvent.Name.firstInstallation.rawValue, parameters: nil)
    }
}

private extension FirebaseAnalyticsClient {

    func setSessionParameters(analyticsUser: AnalyticsUser?) {
        analyticsWrapper.setUserProperty(analyticsUser?.pushNotificationsEnabled.analyticsValue, forName: AnalyticsSessionParameters.pushNotifications.rawValue)
        analyticsWrapper.setUserProperty(analyticsUser?.isBiometricsEnabled.analyticsValue, forName: AnalyticsSessionParameters.isBiometricAuthenticationEnabled.rawValue)
        analyticsWrapper.setUserID(analyticsUser?.id)
    }

    func composeTimedEventName(event: AnalyticsEvent, isStarting: Bool) -> String {
        let suffix = isStarting ? "START" : "STOP"
        return "\(event.collection.rawValue)_\(event.name)_\(suffix)"
    }
}

extension Bool {

    var analyticsValue: String {
        self ? "1" : "0"
    }
}
