//
//  PlaceholderAnalyticsClient.swift
//  Analytics
//

import Foundation
import AnalyticsInterfaces
import StorageInterfaces

public final class PlaceholderAnalyticsClient: AnalyticsClient {
    private let storage: SimpleStorage

    public init(storage: SimpleStorage) {
        self.storage = storage
    }

    public func track(event: AnalyticsEvent) {
        print("🟢 Event tracked: \(event.analyticsName), context: \(event.context)")
    }

    public func start(timedEvent: AnalyticsEvent) {
        print("🏁 Timed event started: \(timedEvent.analyticsName), context: \(timedEvent.context)")
    }

    public func stop(timedEvent: AnalyticsEvent) {
        print("🛑 Timed event stopped: \(timedEvent.analyticsName), context: \(timedEvent.context)")
    }

    public func start(session: AnalyticsSession) {
        print("🏁 Session started: \(session)")
    }

    public func trackFirstInstallation() {
        let hasBeenLaunchedData = storage.data(forKey: StorageKeys.hasBeenLaunched)
        let hasBeenLaunched = hasBeenLaunchedData?.decoded(into: Bool.self) ?? false
        if !hasBeenLaunched {
            print("📱 First installation tracked")
            storage.set(true.encoded(), forKey: StorageKeys.hasBeenLaunched)
        } else {
            print("Subsequent launch - not tracking")
        }
    }
}
