//
//  FakeStorage.swift
//  Sample Feature
//

import Foundation
import StorageInterfaces

@testable import SampleFeature

class FakeStorage: SimpleStorage {
    private(set) var didSynchronize: Bool?
    private(set) var lastSetKey: String?
    private(set) var lastSetValue: Any?
    private(set) var lastRemovedObjectKey: String?

    var simulatedData: [String: Data]?

    func data(forKey defaultName: String) -> Data? {
        simulatedData?[defaultName]
    }

    func set(_ value: Any?, forKey defaultName: String) {
        lastSetKey = defaultName
        lastSetValue = value
    }

    func removeObject(forKey defaultName: String) {
        lastRemovedObjectKey = defaultName
    }

    func synchronize() -> Bool {
        didSynchronize = true
        return true
    }
}
