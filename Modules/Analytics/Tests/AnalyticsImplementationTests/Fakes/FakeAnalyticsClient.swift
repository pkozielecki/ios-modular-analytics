import Foundation
import AnalyticsInterfaces

@testable import AnalyticsImplementation

class FakeAnalyticsClient: AnalyticsClient {
    private (set) var lastTrackedEvent: AnalyticsEvent?
    private (set) var lastStartedTimedEvent: AnalyticsEvent?
    private (set) var lastStoppedTimedEvent: AnalyticsEvent?
    private (set) var lastStartedSession: AnalyticsSession?

    func track(event: AnalyticsEvent) {
        lastTrackedEvent = event
    }

    func start(timedEvent: AnalyticsEvent) {
        lastStartedTimedEvent = timedEvent
    }

    func stop(timedEvent: AnalyticsEvent) {
        lastStoppedTimedEvent = timedEvent
    }

    func start(session: AnalyticsSession) {
        lastStartedSession = session
    }
}
