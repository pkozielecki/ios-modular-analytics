//
//  AnalyticsEventName.swift
//  Analytics
//

import Foundation

extension AnalyticsEvent {

    public enum Name: String {
        case firstInstallation = "first_installation"
        case screenEntered = "screen_entered"

        case passwordGenerated = "password_generated"
        case passwordRetrieved = "password_retrieved"
        case passwordNotSet = "password_not_set"
        case passwordStored = "password_stored"
        case passwordStoreFailed = "password_store_failed"
    }

    public enum ScreenName: String {
        case passwordSetup = "password_setup"
    }
}
