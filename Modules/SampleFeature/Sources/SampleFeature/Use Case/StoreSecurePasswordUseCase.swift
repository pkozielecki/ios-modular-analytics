//
//  StoreSecurePasswordUseCase.swift
//  Sample Feature
//

import Foundation
import DependenciesInterfaces
import StorageInterfaces

public struct StoreSecurePasswordUseCase {
    private let storage: SimpleStorage
    private let delayGenerator: DelayGenerator

    public init(
        storage: SimpleStorage = resolve(),
        delayGenerator: DelayGenerator = LiveDelayGenerator()
    ) {
        self.storage = storage
        self.delayGenerator = delayGenerator
    }

    public func store(password: String) async throws {
        guard !password.isEmpty else {
            throw PasswordError.emptyPassword
        }
        guard let passwordData = password.encoded() else {
            throw PasswordError.unableToEncodePassword
        }
        await delayGenerator.delay(for: Double.random(in: 1...3))
        storage.set(passwordData, forKey: StorageKeys.password)
    }
}

public enum StorageKeys {
    static let password = "password"
}

public enum PasswordError: Error {
    case emptyPassword
    case unableToEncodePassword
}
