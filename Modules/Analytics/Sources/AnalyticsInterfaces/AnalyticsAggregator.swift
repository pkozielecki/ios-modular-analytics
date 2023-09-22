import Foundation

public protocol AnalyticsAggregator: AnalyticsTracker, AnalyticsSessionManager {
    var clients: [AnalyticsClient] { get }
}
