//
//  AppConfig.swift
//  SIP
//
//  Created by Tirupati Balan on 26/09/23.
//

import Foundation

class AppConfig {

    static let adMobAdID: String = ""
    
    /// Turn this `true` to hide the ads if necessary during testing
    static let shouldHideAds: Bool = true
    
    static var SHARED_SECRET = ""
    
    static var MONTHLY_PRODUCT_ID = "com.celerstudio.sip.rc_099_1m"
    static var SIX_MONTH_PRODUCT_ID = "com.celerstudio.sip.rc_599_1y_1wo"
    static var YEARLY_PRODUCT_ID = "com.celerstudio.sip.rc_999_1y_1wo"

    static var TITLE = "Upgrade to Pro"
    static var SUBTITLE = "Get access to all our features"
    static var FEATURES: [String]  = ["iCloud Sync", "Remove Ads"]


    static var PRIVACY_POLICIY_URL = "https://celerstudio.com/privacy-policy"
    static var TERMS_AND_CONDITIONS_URL = "https://celerstudio.com/terms-of-use"
    static var APP_ID = "1092822415"

    static var DISCLIMER_TEXT = "Upon clicking on \"Continue\", payment will be charged to your iTunes account at confirmation of purchase and will automatically renew (at the duration/price selected) unless auto-renew is turned off at least 24 hrs before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period. Current subscription may not be cancelled during the active subscription period; however, you can manage your subscription and/or turn off auto-renewal by visiting your iTunes Account Settings after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable."


    /// PDF Page size. We will be using the size below * `ScaleFactorType` value to increase the output quality
    static let pageWidth: Double = 8.5 * 75 /// U.S. letter size 8.5 x 11
    static let pageHeight: Double = 11 * 75 /// Multiply the size by 72 points per inch

    /// Turn this `true` to see the location where the PDF file is being saved on simulator
    static let showSavedPDFLocation: Bool = true
    
    static let DEVELOPER = "Celerstudio"
    static let COMPABILITY = "iOS 15+"
    static let WEBSITE_LABEL = "Website"
    static let WEBSITE_LINK = "www.celerstudio.com"
    static let RATE_US = "https://apps.apple.com/in/app/sip-calculator/id1092822415"
    
}
