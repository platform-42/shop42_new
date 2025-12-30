//
//  HelpView.swift
//  shops24
//
//  Created by Diederick de Buck on 30/11/2022.
//

import Foundation
import SwiftUI
import P42_extensions
import P42_viewmodifiers
import P42_utils
import P42_screenelements
import P42_colormanager


enum HelpLabel: String {
    case about
    case bugs
    case authentication
    case credits
}


enum SMTPLabel: String {
    case title
    case subject
}


// 1
enum HelpAboutLabel: String {
    case groupboxShops42Title = "Shop42"
    case groupboxVersionTitle = "Version Info"
}


struct HelpAbout: View {
    @Environment(ColorManager.self) var colorManager
    var body: some View {
        PageScrollView {
            VStack(spacing: 20) {
                ContentHeader(
                    titleLabel: HelpLabel.about.rawValue.capitalized,
                    logo: Logo.about.rawValue,
                    logoColor: colorManager.logo,
                    portraitSize: 60,
                )
                StyledGroupBox(
                    title: HelpAboutLabel.groupboxShops42Title.rawValue.uppercased(),
                    icon: Icon.highlight.rawValue,
                    tint: colorManager.tint,
                    background: colorManager.groupBoxBG,
                    stroke: colorManager.stroke
                ) {
                    VStack {
                        Text("**\(Bundle.main.displayName!.capitalized)** app for Shopify store owners is brought to you by **Platform-42.com**")
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                StyledGroupBox(
                    title: HelpAboutLabel.groupboxVersionTitle.rawValue.uppercased(),
                    icon: Icon.highlight.rawValue,
                    tint: colorManager.tint,
                    background: colorManager.groupBoxBG,
                    stroke: colorManager.stroke
                ) {
                    VStack(alignment: .leading) {
                        Text("**Version:** \(Bundle.main.appVersion!)")
                        Text("**Build:** \(Bundle.main.buildVersion!)")
                        Text("**iOS-version:** \(Utils.iosVersion())")
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                Button {
                    if let url = URL(string: "https://platform-42.com") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    ButtonLabelWithImage(
                        buttonImageName: Icon.about.rawValue,
                        buttonTitle: ButtonTitle.visit.rawValue.capitalized,
                        buttonColor: colorManager.navigationText,
                        buttonLabelColor: colorManager.navigationText,
                        buttonBackgroundColor: colorManager.navigationBG
                    )
                }
                .padding(.top, 40)
            }
        }
    }
}


// #2 - Bugs
enum HelpBugsLabel: String {
    case emailTitle = "Faultreport"
    case groupboxBugsTitle = "Report"
}


struct HelpBugs: View {
    static func htmlBody(title: String, application: String, version: String, build: String, osVersion: String) -> String {
        let body = """
            <body>
                <h2>\(title)</h2>
                <h3>\(application)</h3>
                <p>
                    Version: \(version)<br>
                    Build: \(build)<br>
                    iOS-version: \(osVersion)<br>
                </p>
                <br>
        
                <h3>Customer observations</h3>
                <p>
                    Which problems did you encounter?
                </p>
                <br>
        
            </body>
        """
        return body
    }
    @Environment(ColorManager.self) var colorManager
    @Environment(AlertModel.self) var alertModel
    @State private var showAlert: Bool = false
    
    var body: some View {
        PageScrollView {
            VStack(spacing: 20) {
                ContentHeader(
                    titleLabel: HelpLabel.bugs.rawValue.capitalized,
                    logo: Logo.bugs.rawValue,
                    logoColor: colorManager.logo,
                    portraitSize: 60,
                )
                StyledGroupBox(
                    title: HelpBugsLabel.groupboxBugsTitle.rawValue.uppercased(),
                    icon: Icon.highlight.rawValue,
                    tint: colorManager.tint,
                    background: colorManager.groupBoxBG,
                    stroke: colorManager.stroke
                ) {
                    VStack(alignment: .leading) {
                        Text("Help us **improve** \(Bundle.main.displayName!.uppercased()) by reporting any issues you encounter. Our team will review your submission to resolve the problem."
                        )
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                Button {
                    let application = "\(Bundle.main.displayName!)"
                    let version = "\(Bundle.main.appVersion!)"
                    let build = "\(Bundle.main.buildVersion!)"
                    let osVersion = "\(Utils.iosVersion())"
                    let body = HelpBugs.htmlBody(
                        title: "Faultreport",
                        application: application,
                        version: version,
                        build: build,
                        osVersion: osVersion
                    )
                    let result =  EmailController.shared.sendEmail(
                        subject: "\(application) bug-report",
                        body: body,
                        to: "bugs@platform-42.com",
                        isHTML: true
                    )
                    if (!result) {
                        showAlert = true
                        alertModel.showAlert(.mail, diagnostics: .noMailAccount)
                    }
                } label: {
                    ButtonLabelWithImage(
                        buttonImageName: Icon.mail.rawValue,
                        buttonTitle: ButtonTitle.report.rawValue.capitalized,
                        buttonColor: colorManager.navigationText,
                        buttonLabelColor: colorManager.navigationText,
                        buttonBackgroundColor: colorManager.navigationBG
                    )
                }
                .padding(.top, 40)
                .alert(alertModel.topicTitle, isPresented: $showAlert) {
                    Button(ButtonTitle.ok.rawValue.capitalized) {
                    }
                } message: {
                    Text(alertModel.errorMessage)
                }
            }
        }
    }
}


// #3 - Authentication

enum HelpAuthLabel: String {
    case groupboxAuthTitle = "OAuth2"
}


struct HelpAuth: View {
    @Environment(TabsModel.self) var tabsModel
    @Environment(ColorManager.self) var colorManager
    var body: some View {
        PageScrollView {
            VStack(spacing: 20) {
                ContentHeader(
                    titleLabel: HelpLabel.authentication.rawValue.capitalized,
                    logo: Logo.security.rawValue,
                    logoColor: colorManager.logo,
                    portraitSize: 60,
                )
                StyledGroupBox(
                    title: HelpAuthLabel.groupboxAuthTitle.rawValue.uppercased(),
                    icon: Icon.highlight.rawValue,
                    tint: colorManager.tint,
                    background: colorManager.groupBoxBG,
                    stroke: colorManager.stroke
                ) {
                    VStack {
                        Text("**Login** will grant our app \(Bundle.main.displayName!.capitalized), access to your Shopify merchant-data for **read-access**. \n\nPress **logout** button to revoke access.")
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                Button {
                    tabsModel.select(.shops, isAuthenticated: true)
                } label: {
                    ButtonLabelWithImage(
                        buttonImageName: Icon.login.rawValue,
                        buttonTitle: ButtonTitle.login.rawValue.capitalized,
                        buttonColor: colorManager.navigationText,
                        buttonLabelColor: colorManager.navigationText,
                        buttonBackgroundColor: colorManager.navigationBG
                    )
                }
                .padding(.top, 40)
            }
        }
    }
}


enum HelpCreditsLabel: String {
    case groupboxOAuth = "AppAuth"
    case groupboxChatGPT = "ChatGPT"
}


struct HelpCredits: View {
    @Environment(ColorManager.self) var colorManager
    var body: some View {
        PageScrollView {
            VStack(spacing: 20) {
                ContentHeader(
                    titleLabel: HelpLabel.credits.rawValue.capitalized,
                    logo: Logo.credits.rawValue,
                    logoColor: colorManager.logo,
                    portraitSize: 60,
                )
                StyledGroupBox(
                    title: HelpCreditsLabel.groupboxOAuth.rawValue.uppercased(),
                    icon: Icon.highlight.rawValue,
                    tint: colorManager.tint,
                    background: colorManager.groupBoxBG,
                    stroke: colorManager.stroke
                ) {
                    VStack(alignment: .leading) {
                        Text("**AppAuth** implements OAuth2 technology. Copyright (c) 2016 William Denniss")
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                StyledGroupBox(
                    title: HelpCreditsLabel.groupboxChatGPT.rawValue.uppercased(),
                    icon: Icon.highlight.rawValue,
                    tint: colorManager.tint,
                    background: colorManager.groupBoxBG,
                    stroke: colorManager.stroke
                ) {
                    VStack(alignment: .leading) {
                        Text("This app uses insights generated by")
                        Text("**ChatGPT**, developed by OpenAI.")
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
            }
        }
    }
}


struct HelpView: View {
    @Environment(ColorManager.self) var colorManager
    
    func padded<T: View>(_ view: T) -> some View {
        view
        .padding(.bottom, 50)
    }
    
    var body: some View {
        ZStack {
            colorManager.background.ignoresSafeArea()
            TabView {
                padded(HelpAbout())
                padded(HelpBugs())
                padded(HelpAuth())
                padded(HelpCredits())
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}
