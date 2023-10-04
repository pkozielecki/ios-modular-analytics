//
//  RetrieveSecurePasswordUseCase.swift
//  Sample Feature
//

import Foundation
import StorageInterfaces
import DependenciesInterfaces

protocol RetrieveSecurePasswordUseCase {
    func retrieve() async -> String?
}

struct LiveRetrieveSecurePasswordUseCase: RetrieveSecurePasswordUseCase {
    private let storage: SimpleStorage

    init(storage: SimpleStorage = resolve()) {
        self.storage = storage
    }

    func retrieve() async -> String? {
        guard let passwordData = storage.data(forKey: StorageKeys.password) else {
            return nil
        }
        return passwordData.decoded(into: String.self)
    }
}
