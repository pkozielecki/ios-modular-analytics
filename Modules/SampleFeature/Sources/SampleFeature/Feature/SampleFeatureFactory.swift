//
//  SampleFeatureFactory.swift
//  Sample Feature
//

import SwiftUI

public struct SampleFeatureFactory {

    public static func makeInitialView() -> some View {
        // TODO: Make Use Cases
        let viewModel = LiveSampleFeatureViewModel()
        return SampleFeatureView(viewModel: viewModel)
    }
}
