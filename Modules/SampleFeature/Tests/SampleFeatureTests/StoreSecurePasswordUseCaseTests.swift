//
//  StoreSecurePasswordUseCaseTests.swift
//  Sample Feature
//

import Foundation
import XCTest

@testable import SampleFeature

final class StoreSecurePasswordUseCaseTest: XCTestCase {
    var fakeDelayGenerator: FakeDelayGenerator!
    var fakeStorage: FakeStorage!
    var sut: StoreSecurePasswordUseCase!

    override func setUp() {
        fakeStorage = FakeStorage()
        fakeDelayGenerator = FakeDelayGenerator()
        sut = StoreSecurePasswordUseCase(storage: fakeStorage, delayGenerator: fakeDelayGenerator)
    }

    func test_whenPasswordIsEmpty_shouldThrowError() async {
        do {
            try await sut.store(password: "")
            XCTFail("Should throw error")
        } catch {
            //  then:
            XCTAssertEqual(error as? PasswordError, PasswordError.emptyPassword, "Should throw empty password error")
        }
    }

    func test_whenPasswordIsProvided_shouldStoreIt() async {
        //  given:
        let fixturePassword = "123456aabbcc"

        //  when:
        do {
            try await sut.store(password: fixturePassword)
        } catch {
            XCTFail("Should not throw error")
        }

        //  then:
        XCTAssertEqual(fakeStorage.lastSetKey, StorageKeys.password, "Should store password under a specific key")
        XCTAssertEqual(fakeStorage.lastSetValue as? Data, fixturePassword.encoded(), "Should store encoded password")
    }
}