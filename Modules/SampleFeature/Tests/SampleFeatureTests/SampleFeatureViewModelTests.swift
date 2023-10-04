//
//  SampleFeatureViewModelTests.swift
//  Sample Feature
//

import Foundation
import XCTest
import StorageInterfaces

@testable import SampleFeature

final class SampleFeatureViewModelTest: XCTestCase {
    var fakeGenerateSecurePasswordUseCase: FakeGenerateSecurePasswordUseCase!
    var fakeRetrieveSecurePasswordUseCase: FakeRetrieveSecurePasswordUseCase!
    var fakeStoreSecurePasswordUseCase: FakeStoreSecurePasswordUseCase!
    var fakeAnalyticsTracker: FakeAnalyticsTracker!
    var sut: LiveSampleFeatureViewModel!

    override func setUp() {
        fakeGenerateSecurePasswordUseCase = FakeGenerateSecurePasswordUseCase()
        fakeRetrieveSecurePasswordUseCase = FakeRetrieveSecurePasswordUseCase()
        fakeStoreSecurePasswordUseCase = FakeStoreSecurePasswordUseCase()
        fakeAnalyticsTracker = FakeAnalyticsTracker()
        sut = LiveSampleFeatureViewModel(
            generatePasswordUseCase: fakeGenerateSecurePasswordUseCase,
            storePasswordUseCase: fakeStoreSecurePasswordUseCase,
            retrievePasswordUseCase: fakeRetrieveSecurePasswordUseCase,
            analyticsTracker: fakeAnalyticsTracker
        )
    }

    func test_whenViewIsLoaded_andPasswordIsNotStored_shouldReturnProperViewState() async {
        //  initially:
        XCTAssertEqual(sut.viewState, .loading, "Should set proper initial view state")

        //  when:
        await sut.onViewLoaded()

        //  then:
        XCTAssertEqual(sut.viewState, .noPasswordSet, "Should set proper view state")
    }

    func test_whenViewIsLoaded_andPasswordIsRetrievable_shouldReturnProperViewState() async {
        //  given:
        fakeRetrieveSecurePasswordUseCase.simulatedPassword = "password"

        //  when:
        await sut.onViewLoaded()

        //  then:
        XCTAssertEqual(sut.viewState, .passwordRetrieved("password"), "Should set proper view state")
    }

    func test_whenPasswordGenerationRequested_shouldReturnProperViewState() async {
        //  given:
        let fixtureGeneratedPass = "generated pass"
        fakeGenerateSecurePasswordUseCase.simulatedPassword = fixtureGeneratedPass

        //  when:
        await sut.generatePasswordRequested()

        //  then:
        XCTAssertEqual(sut.viewState, .passwordGenerated(fixtureGeneratedPass), "Should set proper view state")
    }

    func test_whenStorePasswordRequested_andThereIsAnError_shouldReturnProperViewState() async {
        //  given:
        let fixtureError = PasswordStorageError.unableToEncodePassword
        fakeStoreSecurePasswordUseCase.simulatedError = fixtureError

        //  when:
        await sut.storePasswordRequested(password: "password")

        //  then:
        XCTAssertEqual(sut.viewState, .error(fixtureError), "Should set proper view state")
    }

    func test_whenStorePasswordRequested_shouldReturnProperViewState() async {
        //  given:
        let fixturePassword = "password"

        //  when:
        await sut.storePasswordRequested(password: fixturePassword)

        //  then:
        XCTAssertEqual(fakeStoreSecurePasswordUseCase.lastStoredPassword, fixturePassword, "Should store password")
    }
}
