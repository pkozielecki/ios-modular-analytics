//
//  GenerateSecurePasswordUseCase.swift
//  Sample Feature
//

import Foundation

public struct GenerateSecurePasswordUseCase {

    // TODO: Move password generation to a separate utility.

    public func generatePassword() async -> String {
        let seconds = UInt64(Int.random(in: 1...6) * 5000000000)
        try? await Task.sleep(nanoseconds: seconds)
        return UUID().uuidString
    }
}
