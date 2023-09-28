//
//  AppUserDefaults.swift
//  SIP
//
//  Created by Tirupati Balan on 26/09/23.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T){
        self.key = key
        self.defaultValue = defaultValue
    }
     
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct AppUserDefaults {
    @UserDefault("appThemeColor", defaultValue: "")
    static var appThemeColor: String
    
    @UserDefault("preferredTheme", defaultValue: 0)
    static var preferredTheme: Int
    
    @UserDefault("shouldshowLocalNotification", defaultValue: false)
    static var shouldshowLocalNotification: Bool
    
    @UserDefault("isOnboarding", defaultValue: true)
    static var isOnboarding: Bool
        
    @UserDefault("paymentId", defaultValue: "")
    static var paymentId: String
    
    @UserDefault("isPremiumUser", defaultValue: true)
    static var isPremiumUser: Bool
}
