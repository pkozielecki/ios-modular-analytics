//
//  RetrieveSecurePasswordUseCase.swift
//  Sample Feature
//

import Foundation
import StorageInterfaces
import DependenciesInterfaces

public struct RetrieveSecurePasswordUseCase {
    private let storage: SimpleStorage

    public init(storage: SimpleStorage = resolve()) {
        self.storage = storage
    }

    public func retrieve() async -> String? {
        guard let passwordData = storage.data(forKey: StorageKeys.password) else {
            return nil
        }
        return passwordData.decoded(into: String.self)
    }
}
