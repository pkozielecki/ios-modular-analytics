//
//  RetrieveSecurePasswordUseCaseTests.swift
//  Sample Feature
//

import Foundation
import XCTest
import StorageInterfaces

@testable import SampleFeature

final class RetrieveSecurePasswordUseCaseTest: XCTestCase {
    var fakeStorage: FakeStorage!
    var sut: LiveRetrieveSecurePasswordUseCase!

    override func setUp() {
        fakeStorage = FakeStorage()
        sut = LiveRetrieveSecurePasswordUseCase(storage: fakeStorage)
    }

    func test_whenNoPasswordIsStored_shouldRetrieveNoPassword() async {
        //  when:
        let password = await sut.retrieve()

        //  then:
        XCTAssertNil(password, "Should not retrieve a password")
    }

    func test_whenPasswordDataIsStored_shouldRetrieveAndDecodeIt() async {
        //  given:
        let fixturePassword = "zzXXXyyy123"
        let fixturePasswordData = fixturePassword.encoded()!
        fakeStorage.simulatedData = [StorageKeys.password: fixturePasswordData]

        //  when:
        let retrievedPassword = await sut.retrieve()

        //  then:
        XCTAssertEqual(retrievedPassword, fixturePassword, "Should retrieve the password")
    }
}
