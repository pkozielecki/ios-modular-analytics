//
//  FakeStoreSecurePasswordUseCase.swift
//  Sample Feature
//

import Foundation

@testable import SampleFeature

final class FakeStoreSecurePasswordUseCase: StoreSecurePasswordUseCase {
    private(set) var lastStoredPassword: String?
    var simulatedError: Error?

    func store(password: String) async throws {
        if let error = simulatedError {
            throw error
        }
        lastStoredPassword = password
    }
}
