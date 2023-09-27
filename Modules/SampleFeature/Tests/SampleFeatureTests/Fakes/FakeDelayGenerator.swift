//
//  FakeDelayGenerator.swift
//  Sample Feature
//

import Foundation

@testable import SampleFeature

final class FakeDelayGenerator: DelayGenerator {

    func delay(for seconds: Double) async {}
}
