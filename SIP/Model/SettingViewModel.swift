//
//  SettingViewModel.swift
//  SIP
//
//  Created by Tirupati Balan on 26/09/23.
//

import Foundation
import SwiftUI

class SettingViewModel: ObservableObject {
    
    @Published var theme: ColorScheme? = nil
    @Published var appThemeColor: Color = Color.appTheme
    @Published var isPremium = AppUserDefaults.isPremiumUser

    @Published var logo: UIImage? {
        didSet {
            /// Convert to data using .pngData() on the image so it will store.  It won't take the UIImage straight up.
            let pngRepresentation = logo?.pngData()
            UserDefaults.standard.set(pngRepresentation, forKey: "logo")
        }
    }
    
    init(){
        theme = getTheme()
        
        if let data = UserDefaults.standard.data(forKey: "logo"){
            self.logo =  UIImage.init(data:data) ?? UIImage(systemName: "applelogo")!.withTintColor(UIColor.label)
        }
                
        theme = getTheme()
    }
    
    func getTheme() -> ColorScheme? {
        let theme = AppUserDefaults.preferredTheme
        var _theme: ColorScheme? = nil
        if theme == 0 {
            _theme = nil
        }else if theme == 1 {
            _theme = ColorScheme.light
        }else {
            _theme = ColorScheme.dark
        }
        return _theme
    }
    
    func changeAppTheme(theme: Int){
        AppUserDefaults.preferredTheme = theme
        self.theme = getTheme()
    }
    
    func changeAppColor(color: Color){
        let hex = color.uiColor().toHexString()
        if hex.count == 7 {
            AppUserDefaults.appThemeColor = hex
        }
        appThemeColor = Color.appTheme
        
    }
    
    func setPremiumUser(paymentId: String){
        isPremium = true
        AppUserDefaults.paymentId = paymentId
        AppUserDefaults.isPremiumUser = true
    }
    
}
