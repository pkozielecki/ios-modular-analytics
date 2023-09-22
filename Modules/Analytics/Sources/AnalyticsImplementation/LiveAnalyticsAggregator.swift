import Foundation
import AnalyticsInterfaces

public final class LiveAnalyticsAggregator: AnalyticsAggregator {
    public let clients: [AnalyticsClient]
    
    public init(clients: [AnalyticsClient]) {
        self.clients = clients
    }

    public func start(session: AnalyticsSession) {
        clients.forEach {
            $0.start(session: session)
        }
    }

    public func track(event: AnalyticsEvent) {
        clients.forEach {
            $0.track(event: event)
        }
    }

    public func start(timedEvent: AnalyticsEvent) {
        clients.forEach {
            $0.start(timedEvent: timedEvent)
        }
    }

    public func stop(timedEvent: AnalyticsEvent) {
        clients.forEach {
            $0.stop(timedEvent: timedEvent)
        }
    }
}
