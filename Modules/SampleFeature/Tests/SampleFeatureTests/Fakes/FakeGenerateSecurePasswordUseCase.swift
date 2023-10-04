//
//  FakeGenerateSecurePasswordUseCase.swift
//  Sample Feature
//

import Foundation

@testable import SampleFeature

final class FakeGenerateSecurePasswordUseCase: GenerateSecurePasswordUseCase {
    var simulatedPassword: String?

    func generatePassword() async -> String {
        simulatedPassword ?? ""
    }
}
