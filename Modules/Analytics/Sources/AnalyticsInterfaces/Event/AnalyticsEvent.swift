import Foundation

public struct AnalyticsEvent: Equatable {
    public let name: String
    public let collection: AnalyticsEventCollection
    public let context: [String: AnyHashable]?

    public init(name: String, collection: AnalyticsEventCollection, context: [String: AnyHashable]?) {
        self.name = name
        self.collection = collection
        self.context = context
    }
}

public extension AnalyticsEvent {

    init(name: String, collection: AnalyticsEventCollection) {
        self.init(name: name, collection: collection, context: nil)
    }

    var analyticsName: String {
        "\(collection.rawValue)_\(name)"
    }
}
