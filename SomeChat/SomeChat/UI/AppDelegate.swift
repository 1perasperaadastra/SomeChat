//
//  AppDelegate.swift
//  SomeChat
//
//  Created by Алексей Махутин on 12.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private enum LifeCycleSate: String, CustomDebugStringConvertible {
        case notRunning
        case inactive
        case active
        case background
        case suspended

        var debugDescription: String {
            switch self {
            case .notRunning:
                return "Not running"
            default: return self.rawValue.capitalized
            }
        }
    }

    var window: UIWindow?
    let coordinator = AppCoordinator()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.log(#function, fromtState: .notRunning, toState: .inactive)
        let window = UIWindow()
        self.window = window
        coordinator.start(window: window)
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.log(#function, fromtState: .inactive, toState: .active)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.log(#function, fromtState: .inactive, toState: .background)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        self.log(#function, fromtState: .active, toState: .inactive)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.log(#function, fromtState: .background, toState: .inactive)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.log(#function, fromtState: .background, toState: .notRunning)
    }

    private func log(_ methodName: String,
                     fromtState oldState: LifeCycleSate,
                     toState newState: LifeCycleSate) {
        Logger.info("Application moved from \(oldState) to \(newState): \(methodName)")
    }
}
