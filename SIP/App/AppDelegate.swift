//
//  AppDelegate.swift
//  SIP
//
//  Created by Tirupati Balan on 26/09/23.
//

import Foundation
import SwiftUI
import FirebaseCore
import SwiftRater

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        SwiftRater.daysUntilPrompt = 3
        SwiftRater.usesUntilPrompt = 10
        SwiftRater.significantUsesUntilPrompt = 3
        SwiftRater.daysBeforeReminding = 1
        SwiftRater.showLaterButton = true
        SwiftRater.debugMode = true
        SwiftRater.appLaunched()
        
        return true
    }
}
