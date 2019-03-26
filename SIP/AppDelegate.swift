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
import GoogleMobileAds
import UserExperior
import Appirater

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        UserExperior.initialize("19b7275d-2f5d-43fd-9f23-add4044ed16f") //Crash report along with user session video recording. Find out more at https://www.userexperior.com
        Fabric.with([Answers.self])
        Appirater.setAppId("1092822415")
    }
}

