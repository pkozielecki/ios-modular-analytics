import Foundation
import XCTest
import AnalyticsInterfaces

@testable import AnalyticsImplementation

final class AnalyticsAggregatorTest: XCTestCase {
    var fakeAnalyticsClient: FakeAnalyticsClient!
    var sut: LiveAnalyticsAggregator!

    override func setUp() {
        fakeAnalyticsClient = FakeAnalyticsClient()
        sut = LiveAnalyticsAggregator(
                clients: [fakeAnalyticsClient]
        )
    }

    func testLoggingEvent() {
        //  given:
        let fixtureEvent = AnalyticsEvent(name: "", collection: .screenTracking, context: nil)

        //  when:
        sut.track(event: fixtureEvent)

        //  then:
        XCTAssertEqual(fakeAnalyticsClient.lastTrackedEvent, fixtureEvent, "Should track an event")
    }

    func testLoggingTimedEvent() {
        //  given:
        let fixtureEvent = AnalyticsEvent(name: "", collection: .screenTracking, context: nil)

        //  when:
        sut.start(timedEvent: fixtureEvent)

        //  then:
        XCTAssertEqual(fakeAnalyticsClient.lastStartedTimedEvent, fixtureEvent, "Should track timed event start")

        //  when:
        sut.stop(timedEvent: fixtureEvent)

        //  then:
        XCTAssertEqual(fakeAnalyticsClient.lastStoppedTimedEvent, fixtureEvent, "Should track timed event stop")
    }

    func testStartingSession() {
        //  initially:
        XCTAssertNil(fakeAnalyticsClient.lastStartedSession, "Should not start a session initially")

        //  given:
        let fixtureUnauthenticatedSession = AnalyticsSession.unauthenticated

        //  when:
        sut.start(session: fixtureUnauthenticatedSession)

        //  then:
        XCTAssertEqual(fakeAnalyticsClient.lastStartedSession, fixtureUnauthenticatedSession, "Should start a session")

        //  given:
        let fixtureEvent = AnalyticsUser(id: "", pushNotificationsEnabled: true, isBiometricsEnabled: false)
        let fixtureAuthenticatedSession = AnalyticsSession.authenticated(fixtureEvent)

        //  when:
        sut.start(session: fixtureAuthenticatedSession)

        //  then:
        XCTAssertEqual(fakeAnalyticsClient.lastStartedSession, fixtureAuthenticatedSession, "Should start a new session")
    }
}
