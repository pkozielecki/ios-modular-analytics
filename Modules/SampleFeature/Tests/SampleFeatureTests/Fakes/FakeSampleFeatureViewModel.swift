//
//  FakeSampleFeatureViewModel.swift
//  Sample Feature
//

import Foundation
import Combine

@testable import SampleFeature

final class FakeSampleFeatureViewModel: SampleFeatureViewModel {
    @Published var viewState: SampleFeatureViewState = .loading
    var viewStatePublished: Published<SampleFeatureViewState> { _viewState }
    var viewStatePublisher: Published<SampleFeatureViewState>.Publisher { $viewState }

    private(set) var didLoadView: Bool?
    private(set) var didRequestGeneratingPassword: Bool?
    private(set) var lastStoredPassword: String?

    func onViewLoaded() async {
        didLoadView = true
    }

    func generatePasswordRequested() async {
        didRequestGeneratingPassword = true
    }

    func storePasswordRequested(password: String) {
        lastStoredPassword = password
    }
}
