//
//  AppDelegate.swift
//  Modular Analytics POC
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    private lazy var dependencyInitizer = DependenciesInitializer()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        dependencyInitizer.registerDependencies()

        return true
    }
}
