import Foundation
import FirebaseAnalytics
import AnalyticsInterfaces

final class FirebaseAnalyticsClient: AnalyticsClient {

    private let analyticsWrapper: FirebaseAnalyticsWrapper.Type

    init(analyticsWrapper: FirebaseAnalyticsWrapper.Type = Analytics.self) {
        self.analyticsWrapper = analyticsWrapper
    }

    func track(event: AnalyticsEvent) {
        analyticsWrapper.logEvent(event.analyticsName, parameters: event.context)
    }

    func start(timedEvent: AnalyticsEvent) {
        let name = composeTimedEventName(event: timedEvent, isStarting: true)
        analyticsWrapper.logEvent(name, parameters: timedEvent.context)
    }

    func stop(timedEvent: AnalyticsEvent) {
        let name = composeTimedEventName(event: timedEvent, isStarting: false)
        analyticsWrapper.logEvent(name, parameters: timedEvent.context)
    }

    func start(session: AnalyticsSession) {
        switch session {
        case .unauthenticated:
            setSessionParameters(analyticsUser: nil)
        case let .authenticated(analyticsUser):
            setSessionParameters(analyticsUser: analyticsUser)
        }
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

private extension Bool {

    var analyticsValue: String {
        self ? "1" : "0"
    }
}
