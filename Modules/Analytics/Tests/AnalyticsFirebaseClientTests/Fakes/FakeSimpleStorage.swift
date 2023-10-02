//
//  FakeSimpleStorage.swift
//  Analytics
//

import Foundation

import StorageInterfaces
@testable import AnalyticsFirebaseClient

final class FakeSimpleStorage: SimpleStorage {
    var simulatedValues: [String: Data]?
    private(set) var lastSetValue: Any?
    private(set) var lastSetKey: String?
    private(set) var lastRemovedKey: String?
    private(set) var didSynchronise: Bool?

    func data(forKey defaultName: String) -> Data? {
        simulatedValues?[defaultName]
    }

    func set(_ value: Any?, forKey defaultName: String) {
        lastSetValue = value
        lastSetKey = defaultName
    }

    func removeObject(forKey defaultName: String) {
        lastRemovedKey = defaultName
    }

    func synchronize() -> Bool {
        didSynchronise = true
        return true
    }
}
