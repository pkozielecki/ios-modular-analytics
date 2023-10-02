//
//  SampleFeatureFactory.swift
//  Sample Feature
//

import SwiftUI

public struct SampleFeatureFactory {

    public static func makeInitialView() -> some View {
        // Discussion: Use cases are set in the VM constructor, so we don't need to pass them here.
        let viewModel = LiveSampleFeatureViewModel()
        return SampleFeatureView(viewModel: viewModel)
    }
}
