//
//  FirebaseAnalyticsClientTests.swift
//  Analytics
//

import Foundation
import XCTest
import AnalyticsInterfaces
import StorageInterfaces

@testable import AnalyticsFirebaseClient

final class Test: XCTestCase {
    let fixtureContext: [String: AnyHashable] = ["foo": "bar"]
    let fixtureCollection = AnalyticsEventCollection.screenTracking
    let fixtureName = AnalyticsEvent.Name.screenEntered
    var fakeFirebaseAnalyticsWrapper: FakeFirebaseAnalyticsWrapper.Type!
    var fakeStorage: FakeSimpleStorage!
    var sut: FirebaseAnalyticsClient!

    override func setUp() {
        fakeStorage = FakeSimpleStorage()
        fakeFirebaseAnalyticsWrapper = FakeFirebaseAnalyticsWrapper.self
        sut = FirebaseAnalyticsClient(storage: fakeStorage, analyticsWrapper: fakeFirebaseAnalyticsWrapper)
    }

    override func tearDown() {
        fakeFirebaseAnalyticsWrapper.clearAll()
    }

    func test_whenTrackingEvent_shouldTranslateItToFirebaseInternalFormat() {
        //  given:
        let fixtureEvent = AnalyticsEvent(name: fixtureName, collection: fixtureCollection, context: fixtureContext)

        //  when:
        sut.track(event: fixtureEvent)

        //  then:
        let expectedName = "\(fixtureCollection.rawValue)_\(fixtureName.rawValue)"
        XCTAssertEqual(fakeFirebaseAnalyticsWrapper.lastLoggedEventName, expectedName, "Should log an event with a proper name")
        XCTAssertEqual(
            fakeFirebaseAnalyticsWrapper.lastLoggedEventParameters as? [String: AnyHashable],
            fixtureContext,
            "Should log an event with a proper context"
        )
    }

    func test_whenTrackingTimedEvent_shouldTranslateItToFirebaseInternalFormat() {
        //  given:
        let fixtureEvent = AnalyticsEvent(name: fixtureName, collection: fixtureCollection, context: fixtureContext)

        //  when:
        sut.start(timedEvent: fixtureEvent)

        //  then:
        let expectedStartName = "\(fixtureCollection.rawValue)_\(fixtureName)_START"
        XCTAssertEqual(fakeFirebaseAnalyticsWrapper.lastLoggedEventName, expectedStartName, "Should log start of an event with a proper name")
        XCTAssertEqual(
            fakeFirebaseAnalyticsWrapper.lastLoggedEventParameters as? [String: AnyHashable],
            fixtureContext,
            "Should log an event with a proper context"
        )

        //  when:
        sut.stop(timedEvent: fixtureEvent)

        //  then:
        let expectedStopName = "\(fixtureCollection.rawValue)_\(fixtureName)_STOP"
        XCTAssertEqual(fakeFirebaseAnalyticsWrapper.lastLoggedEventName, expectedStopName, "Should log stop of an event with a proper name")
        XCTAssertEqual(
            fakeFirebaseAnalyticsWrapper.lastLoggedEventParameters as? [String: AnyHashable],
            fixtureContext,
            "Should log an event with a proper context"
        )
    }

    func test_whenStartingSession_shouldSetProperUserAndTheirProperties() {
        //  given:
        let fixtureUserId = "fixtureUserId"
        let fixtureIsBiometricsEnabled = true
        let fixturePushNotificationsEnabled = true
        let fixtureAnalyticsUser = AnalyticsUser(
            id: fixtureUserId,
            pushNotificationsEnabled: fixturePushNotificationsEnabled,
            isBiometricsEnabled: fixtureIsBiometricsEnabled
        )
        let fixtureAuthenticatedSession = AnalyticsSession.authenticated(fixtureAnalyticsUser)

        //  when:
        sut.start(session: fixtureAuthenticatedSession)

        //  then:
        XCTAssertEqual(fakeFirebaseAnalyticsWrapper.lastSetUserId, fixtureUserId, "Should register user with a proper id")
        XCTAssertEqual(
            fakeFirebaseAnalyticsWrapper.lastSetUserProperties["notifications_enabled"],
            fixturePushNotificationsEnabled.analyticsValue,
            "Should annotate if user has push notifications enabled"
        )
        XCTAssertEqual(
            fakeFirebaseAnalyticsWrapper.lastSetUserProperties["is_biometric_enabled"],
            fixtureIsBiometricsEnabled.analyticsValue,
            "Should annotate if user has biometrics enabled"
        )

        //  finally:
        fakeFirebaseAnalyticsWrapper.clearAll()

        //  given:
        let fixtureUnauthenticatedSession = AnalyticsSession.unauthenticated

        //  when:
        sut.start(session: fixtureUnauthenticatedSession)

        //  then:
        XCTAssertNil(fakeFirebaseAnalyticsWrapper.lastSetUserId, "Should clear user")
        XCTAssertNil(fakeFirebaseAnalyticsWrapper.lastSetUserProperties["notifications_enabled"], "Should user notifications property")
        XCTAssertNil(fakeFirebaseAnalyticsWrapper.lastSetUserProperties["is_biometric_enabled"], "Should user biometrics property")
    }

    func test_whenLaunchingAppForFirstTime_shouldSendProperEvent() async {
        //  given:
        fakeStorage.simulatedValues = nil

        //  when:
        sut.trackFirstInstallation()

        //  then:
        XCTAssertEqual(fakeFirebaseAnalyticsWrapper.lastLoggedEventName, AnalyticsEvent.Name.firstInstallation.rawValue, "Should log first installation event")
    }

    func test_whenLaunchingAppForSubsequentTime_shouldNotSendAnyEvent() async {
        //  given:
        let fixtureData = true.encoded()
        fakeStorage.simulatedValues = [StorageKeys.hasBeenLaunched: fixtureData!]

        //  when:
        sut.trackFirstInstallation()

        //  then:
        XCTAssertNil(fakeFirebaseAnalyticsWrapper.lastLoggedEventName, "Should not track installation event")
    }
}
