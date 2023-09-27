//
//  GenerateSecurePasswordUseCase.swift
//  Sample Feature
//

import Foundation

public struct GenerateSecurePasswordUseCase {
    private let delayGenerator: DelayGenerator

    public init(
        delayGenerator: DelayGenerator = LiveDelayGenerator()
    ) {
        self.delayGenerator = delayGenerator
    }

    // TODO: Move password generation to a separate utility.

    public func generatePassword() async -> String {
        await delayGenerator.delay(for: Double.random(in: 0.5...1))
        return UUID().uuidString
    }
}
