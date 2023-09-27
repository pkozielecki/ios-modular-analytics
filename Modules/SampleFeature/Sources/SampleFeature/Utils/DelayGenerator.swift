//
//  DelayGenerator.swift
//  Sample Feature
//

import Foundation

public protocol DelayGenerator {

    func delay(for seconds: Double) async -> Void
}

public final class LiveDelayGenerator: DelayGenerator {

    public init() {}

    public func delay(for seconds: Double) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1000000000))
    }
}
