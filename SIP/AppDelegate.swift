//
//  AppDelegate.swift
//  SIP
//
//  Created by Tirupati Balan on 12/03/16.
//  Copyright © 2016 CelerStudio. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.defaultInitialization()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    func defaultInitialization() {
        Fabric.with([Crashlytics.self])
        Fabric.with([Answers.self])
        Flurry.startSession("PC2RRXHW3W7283GD5WSV")
        Flurry.setCrashReportingEnabled(true)
        
        Appirater.setAppId("1092822415")
        Appirater.setDaysUntilPrompt(7)
        Appirater.setUsesUntilPrompt(5)
        Appirater.setSignificantEventsUntilPrompt(-1)
        Appirater.setTimeBeforeReminding(2)
        Appirater.setDebug(false)
        Appirater.appLaunched(true)
    }
}

