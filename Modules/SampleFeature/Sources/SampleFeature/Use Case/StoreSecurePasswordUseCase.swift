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
            throw PasswordStorageError.emptyPassword
        }
        guard let passwordData = password.encoded() else {
            throw PasswordStorageError.unableToEncodePassword
        }
        await delayGenerator.delay(for: Double.random(in: 1...3))
        storage.set(passwordData, forKey: StorageKeys.password)
    }
}

public enum StorageKeys {
    static let password = "password"
}

public enum PasswordStorageError: LocalizedError {
    case emptyPassword
    case unableToEncodePassword
    case unknown

    public var errorDescription: String? {
        switch self {
        case .emptyPassword:
            return "Password cannot be empty"
        case .unableToEncodePassword:
            return "Unable to encode password"
        case .unknown:
            return "Unknown error has occurred"
        }
    }
}
