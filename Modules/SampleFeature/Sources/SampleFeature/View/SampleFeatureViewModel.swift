//
//  SampleFeatureViewModel.swift
//  Sample Feature
//

import SwiftUI
import Combine
import DependenciesInterfaces
import AnalyticsInterfaces

enum SampleFeatureViewState {
    case loading
    case passwordRetrieved(String)
    case noPasswordSet
    case passwordGenerated(String)
    case settingPassword(String)
    case error(LocalizedError)
}

protocol SampleFeatureViewModel: ObservableObject {
    var viewState: SampleFeatureViewState { get }
    var viewStatePublished: Published<SampleFeatureViewState> { get }
    var viewStatePublisher: Published<SampleFeatureViewState>.Publisher { get }

    func onViewLoaded() async
    func generatePasswordRequested() async
    func storePasswordRequested(password: String) async
}

final class LiveSampleFeatureViewModel: SampleFeatureViewModel {
    @Published var viewState = SampleFeatureViewState.loading

    private let generatePasswordUseCase: GenerateSecurePasswordUseCase
    private let storePasswordUseCase: StoreSecurePasswordUseCase
    private let retrievePasswordUseCase: RetrieveSecurePasswordUseCase
    private let analyticsTracker: AnalyticsTracker
    private var initialPasswordSet: Bool? = false

    init(
        generatePasswordUseCase: GenerateSecurePasswordUseCase = LiveGenerateSecurePasswordUseCase(),
        storePasswordUseCase: StoreSecurePasswordUseCase = LiveStoreSecurePasswordUseCase(),
        retrievePasswordUseCase: RetrieveSecurePasswordUseCase = LiveRetrieveSecurePasswordUseCase(),
        analyticsTracker: AnalyticsTracker = resolve()
    ) {
        self.generatePasswordUseCase = generatePasswordUseCase
        self.storePasswordUseCase = storePasswordUseCase
        self.retrievePasswordUseCase = retrievePasswordUseCase
        self.analyticsTracker = analyticsTracker
    }

    @MainActor func onViewLoaded() async {
        trackScreenEntered()
        if let password = await retrievePasswordUseCase.retrieve() {
            initialPasswordSet = false
            analyticsTracker.start(timedEvent: .makePasswordEvent(name: .passwordUpdate))
            viewState = .passwordRetrieved(password)
            trackPasswordEventNamed(.passwordRetrieved)
        } else {
            initialPasswordSet = true
            analyticsTracker.start(timedEvent: .makePasswordEvent(name: .passwordCreation))
            viewState = .noPasswordSet
            trackPasswordEventNamed(.passwordNotSet)
        }
    }

    @MainActor func generatePasswordRequested() async {
        trackPasswordEventNamed(.passwordGenerated)
        viewState = .loading
        let password = await generatePasswordUseCase.generatePassword()
        viewState = .passwordGenerated(password)
    }

    @MainActor func storePasswordRequested(password: String) async {
        do {
            viewState = .settingPassword(password)
            try await storePasswordUseCase.store(password: password)
            viewState = .passwordRetrieved(password)
            trackPasswordEventNamed(.passwordStored)
            trackPasswordSettingProcessEnd()
        } catch let error as LocalizedError {
            viewState = .error(error)
            trackPasswordEventNamed(.passwordStoreFailed)
        } catch {
            viewState = .error(PasswordStorageError.unknown)
            trackPasswordEventNamed(.passwordStoreFailed)
        }
    }
}

private extension LiveSampleFeatureViewModel {

    func trackScreenEntered() {
        analyticsTracker.track(event: .makeScreenEnteredEvent(name: .passwordSetup))
    }

    func trackPasswordEventNamed(_ name: AnalyticsEvent.Name) {
        analyticsTracker.track(event: .makePasswordEvent(name: name))
    }

    func trackPasswordSettingProcessEnd() {
        guard let initialPasswordSet else { return }
        if initialPasswordSet {
            analyticsTracker.stop(timedEvent: .makePasswordEvent(name: .passwordCreation))
        } else {
            analyticsTracker.stop(timedEvent: .makePasswordEvent(name: .passwordUpdate))
        }
        self.initialPasswordSet = nil
    }
}

extension LiveSampleFeatureViewModel {
    var viewStatePublished: Published<SampleFeatureViewState> { _viewState }
    var viewStatePublisher: Published<SampleFeatureViewState>.Publisher { $viewState }
}

extension SampleFeatureViewState: Equatable {
    static func == (lhs: SampleFeatureViewState, rhs: SampleFeatureViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.passwordRetrieved(lhsPassword), .passwordRetrieved(rhsPassword)):
            return lhsPassword == rhsPassword
        case (.noPasswordSet, .noPasswordSet):
            return true
        case let (.passwordGenerated(lhsPassword), .passwordGenerated(rhsPassword)):
            return lhsPassword == rhsPassword
        case let (.settingPassword(lhsPassword), .settingPassword(rhsPassword)):
            return lhsPassword == rhsPassword
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.errorDescription == rhsError.errorDescription
        default:
            return false
        }
    }
}
