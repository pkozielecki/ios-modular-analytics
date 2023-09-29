//
//  PreviewSampleFeatureViewModel.swift
//  Sample Feature
//

import SwiftUI

final class PreviewSampleFeatureViewModel: SampleFeatureViewModel {
    @Published var viewState: SampleFeatureViewState = .loading
    var viewStatePublished: Published<SampleFeatureViewState> { _viewState }
    var viewStatePublisher: Published<SampleFeatureViewState>.Publisher { $viewState }

    func onViewLoaded() async {
        print("onViewLoaded")
    }

    func generatePasswordRequested() async {
        print("generatePasswordRequested")
    }

    func storePasswordRequested(password: String) {
        print("storePasswordRequested: \(password)")
    }
}
