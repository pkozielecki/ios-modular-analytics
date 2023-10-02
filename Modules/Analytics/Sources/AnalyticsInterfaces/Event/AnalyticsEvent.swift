//
//  AnalyticsEvent.swift
//  Analytics
//

import Foundation

public struct AnalyticsEvent: Equatable {
    public let name: AnalyticsEvent.Name
    public let collection: AnalyticsEventCollection
    public let context: [String: AnyHashable]?

    public init(name: AnalyticsEvent.Name, collection: AnalyticsEventCollection, context: [String: AnyHashable]?) {
        self.name = name
        self.collection = collection
        self.context = context
    }
}

public extension AnalyticsEvent {

    init(name: AnalyticsEvent.Name, collection: AnalyticsEventCollection) {
        self.init(name: name, collection: collection, context: nil)
    }

    var analyticsName: String {
        "\(collection.rawValue)_\(name.rawValue)"
    }

    static func makeScreenEnteredEvent(name: AnalyticsEvent.ScreenName) -> AnalyticsEvent {
        let context = ["screen_name": name.rawValue]
        return AnalyticsEvent(name: .screenEntered, collection: .screenTracking, context: context)
    }

    static func makePasswordEvent(name: AnalyticsEvent.Name, context: [String: AnyHashable]? = nil) -> AnalyticsEvent {
        AnalyticsEvent(name: name, collection: .passwordSetup, context: context)
    }
}
