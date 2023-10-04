//
//  AppDelegate.swift
//  Modular Analytics POC
//

import UIKit
import DependenciesInterfaces
import AnalyticsInterfaces

final class AppDelegate: NSObject, UIApplicationDelegate {
    private lazy var dependencyInitializer = DependenciesInitializer()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        dependencyInitializer.registerDependencies()
        trackFirstLaunchIfNeeded()
        return true
    }
}

private extension AppDelegate  {

    func trackFirstLaunchIfNeeded() {
        let analyticsTracker: AnalyticsTracker = resolve()
        analyticsTracker.trackFirstInstallation()
    }
}
