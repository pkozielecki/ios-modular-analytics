//
//  PreviewSampleFeatureViewModel.swift
//  Sample Feature
//

import SwiftUI

final class PreviewSampleFeatureViewModel: SampleFeatureViewModel {
    @Published var viewState: SampleFeatureViewState = .loading
    var viewStatePublished: Published<SampleFeatureViewState> { _viewState }
    var viewStatePublisher: Published<SampleFeatureViewState>.Publisher { $viewState }

    func onViewLoaded() {
        print("onViewLoaded")
    }

    func retrievePasswordRequested() {
        print("retrievePasswordRequested")
    }

    func generatePasswordRequested() {
        print("generatePasswordRequested")
    }

    func storePasswordRequested() {
        print("storePasswordRequested")
    }
}
