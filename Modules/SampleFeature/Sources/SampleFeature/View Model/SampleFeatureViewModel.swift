//
//  SampleFeatureViewModel.swift
//  Sample Feature
//

import SwiftUI
import Combine

enum SampleFeatureViewState {
    case loading
    case passwordRetrieved(String)
    case noPasswordSet
    case settingPassword(String)
    case error(Error)
}

protocol SampleFeatureViewModel: ObservableObject {
    var viewState: SampleFeatureViewState { get }
    var viewStatePublished: Published<SampleFeatureViewState> { get }
    var viewStatePublisher: Published<SampleFeatureViewState>.Publisher { get }

    func onViewLoaded()
    func retrievePasswordRequested()
    func generatePasswordRequested()
    func storePasswordRequested()
}

final class LiveSampleFeatureViewModel: SampleFeatureViewModel {
    @Published var viewState = SampleFeatureViewState.loading

    func onViewLoaded() {
        print("onViewLoaded")
    }

    func retrievePasswordRequested() {}

    func generatePasswordRequested() {}

    func storePasswordRequested() {}
}

extension LiveSampleFeatureViewModel {
    var viewStatePublished: Published<SampleFeatureViewState> { _viewState }
    var viewStatePublisher: Published<SampleFeatureViewState>.Publisher { $viewState }
}
