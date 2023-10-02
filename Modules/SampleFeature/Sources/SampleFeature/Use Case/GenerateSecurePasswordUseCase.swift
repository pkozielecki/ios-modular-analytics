//
//  GenerateSecurePasswordUseCase.swift
//  Sample Feature
//

import Foundation

struct GenerateSecurePasswordUseCase {
    private let delayGenerator: DelayGenerator

    init(
        delayGenerator: DelayGenerator = LiveDelayGenerator()
    ) {
        self.delayGenerator = delayGenerator
    }

    // TODO: Move password generation to a separate utility.

    func generatePassword() async -> String {
        await delayGenerator.delay(for: Double.random(in: 0.5...1))
        return UUID().uuidString
    }
}
