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
    func storePasswordRequested(password: String)
}

final class LiveSampleFeatureViewModel: SampleFeatureViewModel {
    @Published var viewState = SampleFeatureViewState.loading

    private let generatePasswordUseCase: GenerateSecurePasswordUseCase
    private let storePasswordUseCase: StoreSecurePasswordUseCase
    private let retrievePasswordUseCase: RetrieveSecurePasswordUseCase

    init(
        generatePasswordUseCase: GenerateSecurePasswordUseCase = GenerateSecurePasswordUseCase(),
        storePasswordUseCase: StoreSecurePasswordUseCase = StoreSecurePasswordUseCase(),
        retrievePasswordUseCase: RetrieveSecurePasswordUseCase = RetrieveSecurePasswordUseCase()
    ) {
        self.generatePasswordUseCase = generatePasswordUseCase
        self.storePasswordUseCase = storePasswordUseCase
        self.retrievePasswordUseCase = retrievePasswordUseCase
    }

    @MainActor func onViewLoaded() async {
        // TODO: call analytics
        if let password = await retrievePasswordUseCase.retrieve() {
            viewState = .passwordRetrieved(password)
        } else {
            viewState = .noPasswordSet
        }
    }

    @MainActor func generatePasswordRequested() async {
        viewState = .loading
        let password = await generatePasswordUseCase.generatePassword()
        viewState = .passwordGenerated(password)
    }

    func storePasswordRequested(password: String) {
        Task { @MainActor in
            do {
                viewState = .settingPassword(password)
                try await storePasswordUseCase.store(password: password)
                viewState = .passwordRetrieved(password)
            } catch let error as LocalizedError {
                viewState = .error(error)
            } catch {
                viewState = .error(PasswordStorageError.unknown)
            }
        }
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
