//
//  StoreSecurePasswordUseCase.swift
//  Sample Feature
//

import Foundation
import DependenciesInterfaces
import StorageInterfaces

public struct StoreSecurePasswordUseCase {
    private let storage: SimpleStorage

    public init(storage: SimpleStorage = resolve()) {
        self.storage = storage
    }

    public func store(password: String) async throws {
        guard password.isEmpty else {
            throw PasswordError.emptyPassword
        }
        guard let passwordData = password.encoded() else {
            throw PasswordError.unableToEncodePassword
        }
        let seconds = UInt64(Int.random(in: 1...6) * 5000000000)
        try? await Task.sleep(nanoseconds: seconds)
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
