//
//  SettingView.swift
//  SIP
//
//  Created by Tirupati Balan on 26/09/23.
//

import Foundation
import SwiftUI
import MessageUI
import SwiftRater
import SafariServices

struct SettingView: View {
    @EnvironmentObject var settingsViewModel: SettingViewModel
    @State private var themeType = AppUserDefaults.preferredTheme
    @State private var showSubscriptionFlow: Bool = false
    @State private var showMailView = false
    @State private var showShareSheet = false
    @State private var showSafariView = false
    
    var body: some View {
            Form {
                Section(header: Text("Preferences")) {
                    
                    ColorPicker("Tint Color", selection:$settingsViewModel.appThemeColor.onChange(colorChange))
                   
                    HStack{
                        Text("Theme")
                        Spacer()
                        Picker("", selection: $themeType.onChange(themeChange)){
                            Text("System").tag(0)
                            Text("Light").tag(1)
                            Text("Dark").tag(2)
                        }
                        .fixedSize()
                        .pickerStyle(.segmented)
                    }
                }
                
                Section(header: Text("Support"),
                        footer: SettingsRowView(name: "iCloud Sync Enabled", content: "\(Bundle.main.versionNumber).\(Bundle.main.buildNumber)")
                                ) {

                    Button(action: {
                        showMailView.toggle()
                    }) {
                        Text("Send Feedback")
                            .tint(Color.appTheme)
                    }
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $showMailView) {
                        MailView(isShowing: $showMailView, recipient: "tirupati.balan@gmail.com", subject: "Sippy: Investment Calculator")
                    }

                    Button(action: {
                        showShareSheet.toggle()
                    }) {
                        Text("Share This App")
                            .tint(Color.appTheme)
                    }
                    .sheet(isPresented: $showShareSheet) {
                        ShareSheet(activityItems: [URL(string: "https://apps.apple.com/in/app/sip-calculator/id1092822415")!])
                    }

                    Button(action: {
                        rateApp()
                    }) {
                        Text("Rate Us")
                            .tint(Color.appTheme)
                    }
                }
            }
            .navigationTitle("Settings")
    }
    
    func rateApp() {
        guard let url = URL(string: "https://apps.apple.com/in/app/sip-calculator/id1092822415?action=write-review") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func themeChange(_ tag: Int){
        settingsViewModel.changeAppTheme(theme: tag)
    }
    
    func colorChange(_ color: Color){
        settingsViewModel.changeAppColor(color: color)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(SettingViewModel())
    }
}


struct SettingsLabelView: View {
    
    var labelText: String
    var labelImage: String
    
    var body: some View {
        HStack {
            Text(labelText.uppercased())
            Spacer()
            Image(systemName: labelImage )
                .font(.headline)
        }
    }
}


struct SettingsRowView: View {
    
    var name: String
    var content: String? = nil
    var linkLabel: String? = nil
    var linkDestination: String? = nil
    
    var body: some View {
        VStack {
            HStack{
                Text(LocalizedStringKey(name)).foregroundColor(.gray)
                Spacer()
                if content != nil {
                    Text(content!)
                } else if(linkLabel != nil && linkDestination != nil){
                    Link(linkLabel!, destination: URL(string: "https://\(linkDestination!)")!)
                    Image(systemName: "arrow.up.right.square").foregroundColor(.pink)
                } else {
                    EmptyView()
                }
            }
        }
    }
}


extension Bundle {
    
    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
    
    var bundleId: String {
        return bundleIdentifier!
    }
    
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
    
}

struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    var recipient: String
    var subject: String

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mailController = MFMailComposeViewController()
        mailController.setToRecipients([recipient])
        mailController.setSubject(subject)
        mailController.setMessageBody(createEmailBody(), isHTML: false)
        mailController.mailComposeDelegate = context.coordinator
        return mailController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {}

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool

        init(isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            isShowing = false
        }
    }

    func createEmailBody() -> String {
        let device = UIDevice.current
        let version = "\(Bundle.main.versionNumber).\(Bundle.main.buildNumber)"
        let systemVersion = device.systemVersion
        let modelName = device.modelName

        let emailBody = """
        -- Please write your feedback above this line --

        App Version: \(version)
        Device: \(modelName)
        iOS Version: \(systemVersion)
        Premium User: \(AppUserDefaults.isPremiumUser)
        """

        return emailBody
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let appURL = activityItems.first as? URL
        let shareMessage = """
        Hey! Check out this amazing app called Sippy. It makes your SIP calculation super easy. Download it now: \(appURL?.absoluteString ?? "")
        """

        let controller = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        return identifier
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    let tint: Color
    @Binding var isShowing: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = UIColor(Color.appTheme)
        return safariViewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        isShowing = false
    }
}
