import Foundation

public enum AnalyticsSession: Equatable {
    case authenticated(AnalyticsUser)
    case unauthenticated
}