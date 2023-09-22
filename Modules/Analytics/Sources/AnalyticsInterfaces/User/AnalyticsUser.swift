import Foundation

public struct AnalyticsUser: Equatable {
    public let id: String
    public let pushNotificationsEnabled: Bool
    public let isBiometricsEnabled: Bool

    public init(id: String, pushNotificationsEnabled: Bool, isBiometricsEnabled: Bool) {
        self.id = id
        self.pushNotificationsEnabled = pushNotificationsEnabled
        self.isBiometricsEnabled = isBiometricsEnabled
    }
}
