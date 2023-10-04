//
//  SampleFeatureViewTests.swift
//  Sample Feature
//

import SwiftUI
import UIKit
import XCTest
import SnapshotTesting
import Combine

@testable import SampleFeature

final class SampleFeatureViewTest: XCTestCase {
    var fakeViewModel: FakeSampleFeatureViewModel!
    var sut: SampleFeatureView<FakeSampleFeatureViewModel>!

    override func setUp() {
        UIView.setAnimationsEnabled(false)
        fakeViewModel = FakeSampleFeatureViewModel()
        sut = SampleFeatureView(viewModel: fakeViewModel)
    }

    override func tearDown() {
        fakeViewModel = nil
        sut = nil
        UIView.setAnimationsEnabled(true)
    }

    func test_whenProperViewIsLoading_shouldRenderViewAccordingly() {
        fakeViewModel.objectWillChange.send()
        performSnapshot(state: .loading, named: "SampleFeatureView_loading")
    }

    func test_whenNoPasswordIsSet_shouldRenderViewAccordingly() {
        performSnapshot(state: .noPasswordSet, named: "SampleFeatureView_noPasswordSet")
    }

    func test_whenPasswordIsRetrieved_shouldRenderViewAccordingly() {
        performSnapshot(state: .passwordRetrieved("Retrieved Password"), named: "SampleFeatureView_passwordRetrieved")
    }

    func test_whenPasswordRetrievalThrewError_shouldRenderViewAccordingly() {
        performSnapshot(state: .error(PasswordStorageError.unableToEncodePassword), named: "SampleFeatureView_passwordStorageError")
    }

    func test_whenPasswordIsBeingSet_shouldRenderViewAccordingly() {
        performSnapshot(state: .settingPassword("Password"), named: "SampleFeatureView_settingPassword")
    }

    func test_whenPasswordIsGenerated_shouldRenderViewAccordingly() {
        performSnapshot(state: .settingPassword("Password"), named: "SampleFeatureView_passwordGenerated")
    }
}

private extension SampleFeatureViewTest {

    func performSnapshot(
        state: SampleFeatureViewState,
        named: String,
        file: StaticString = #file,
        testName: String = "SNAPSHOT",
        line: UInt = #line
    ) {
        //  given:
        let viewController = UIHostingController(rootView: sut)
        viewController.overrideUserInterfaceStyle = .light
        viewController.loadViewIfNeeded()
        viewController.viewWillAppear(false)
        viewController.viewDidAppear(false)
        waitForDisplayListRedraw()

        //  when:
        fakeViewModel.viewState = state
        waitForDisplayListRedraw()

        //  then:
        assertSnapshot(of: viewController, as: .image(on: .iPhone12, precision: 0.99, perceptualPrecision: 0.98), named: named, file: file, testName: testName, line: line)
    }
}

extension SampleFeatureViewTest {

    func waitForDisplayListRedraw(delay: Double = 0.1) {
        let expectation = expectation(description: "waitForDisplayListRedraw")

        //  when:
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            expectation.fulfill()
        }

        //  then:
        wait(for: [expectation])
    }
}
