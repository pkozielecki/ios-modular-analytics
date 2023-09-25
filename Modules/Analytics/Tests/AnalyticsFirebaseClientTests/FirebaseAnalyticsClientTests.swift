import Foundation
import XCTest
import AnalyticsInterfaces

@testable import AnalyticsFirebaseClient

final class Test: XCTestCase {
    let fixtureContext: [String: AnyHashable] = ["foo": "bar"]
    let fixtureCollection = AnalyticsEventCollection.screenTracking
    let fixtureName = "fixtureName"
    var fakeFirebaseAnalyticsWrapper: FakeFirebaseAnalyticsWrapper.Type!
    var sut: FirebaseAnalyticsClient!

    override func setUp() {
        fakeFirebaseAnalyticsWrapper = FakeFirebaseAnalyticsWrapper.self
        sut = FirebaseAnalyticsClient(analyticsWrapper: fakeFirebaseAnalyticsWrapper)
    }

    override func tearDown() {
        fakeFirebaseAnalyticsWrapper.clearAll()
    }

    func test_whenX_shouldY() {
        XCTAssertNotNil(sut, "")
    }

    func test_whenTrackingEvent_shouldTranslateItToFirebaseInternalFormat() {
        //  given:
        let fixtureEvent = AnalyticsEvent(name: fixtureName, collection: fixtureCollection, context: fixtureContext)

        //  when:
        sut.track(event: fixtureEvent)

        //  then:
        let expectedName = "\(fixtureCollection.rawValue)_\(fixtureName)"
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
}
