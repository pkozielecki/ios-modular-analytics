//
//  FakeRetrieveSecurePasswordUseCase.swift
//  Sample Feature
//

import Foundation

@testable import SampleFeature

final class FakeRetrieveSecurePasswordUseCase: RetrieveSecurePasswordUseCase {
    var simulatedPassword: String?

    func retrieve() async -> String? {
        simulatedPassword
    }
}
