//
//  FirebaseAnalyticsWrapper.swift
//  Analytics
//

import Foundation
import FirebaseAnalytics

public protocol FirebaseAnalyticsWrapper: AnyObject {

    static func logEvent(_ name: String, parameters: [String: Any]?)

    static func setUserProperty(_ value: String?, forName name: String)

    static func setUserID(_ userID: String?)

    static func setAnalyticsCollectionEnabled(_ enabled: Bool)
}

extension Analytics: FirebaseAnalyticsWrapper {}
