import Foundation
import AnalyticsInterfaces

@testable import AnalyticsFirebaseClient

final class FakeFirebaseAnalyticsWrapper: FirebaseAnalyticsWrapper {
    static private (set) var lastLoggedEventName: String?
    static private (set) var lastLoggedEventParameters: [String: Any]?
    static private (set) var lastSetUserId: String?
    static private (set) var lastSetUserProperties = [String:String]()

    class func logEvent(_ name: String, parameters: [String: Any]?) {
        lastLoggedEventName = name
        lastLoggedEventParameters = parameters
    }

    class func setUserProperty(_ value: String?, forName name: String) {
        lastSetUserProperties[name] = value
    }

    class func setUserID(_ userID: String?) {
        lastSetUserId = userID
    }

    class func setAnalyticsCollectionEnabled(_ enabled: Bool) {
    }
}

extension FakeFirebaseAnalyticsWrapper {

    public static func clearAll() {
        lastLoggedEventName = nil
        lastLoggedEventParameters = nil
        lastSetUserProperties = [:]
        lastSetUserId = nil
    }
}