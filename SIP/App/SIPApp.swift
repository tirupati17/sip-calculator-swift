//
//  SIPApp.swift
//  SIP
//
//  Created by Tirupati Balan on 15/05/23.
//

import Foundation
import SwiftUI

@main
struct SIPApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var settingViewModel = SettingViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(settingViewModel.getTheme())
                .environmentObject(settingViewModel)
        }
    }
}
