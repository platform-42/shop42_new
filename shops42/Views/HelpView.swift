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


enum HelpLabel: String {
    case about
    case bugs
    case authentication
    case revoke = "Revoke License"
    case credits
}

enum SMTPLabel: String {
    case title
    case subject
}

// 1
struct HelpAbout: View {
    
    @State private var isPressed = false
    
    var body: some View {
        VScrollView {
            VStack {
                ContentHeader(
                    titleLabel: HelpLabel.about,
                    logo: Logo.about,
                    logoColor: Color(OrnamentColor.logo.rawValue),
                    portraitSize: Squares.portrait.rawValue
                )
                Text("\(Bundle.main.displayName!.capitalized) app for Shopify store owners is brought to you by Platform-42.com")
                    .modifier(P(labelColor: Color(LabelColor.p.rawValue)))
                Divider()
                VStack {
                    Text("Version: \(Bundle.main.appVersion!)")
                    Text("Build: \(Bundle.main.buildVersion!)")
                    Text("iOS-version: \(Utils.iosVersion())")
                }
                .modifier(P(labelColor: Color(LabelColor.p.rawValue)))
                Spacer()
                Button {
                    if let url = URL(string: "https://platform-42.com") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    ButtonLabelWithImage(
                        buttonImageName: Icon.about.rawValue,
                        buttonTitle: ButtonTitle.visit.rawValue.capitalized,
                        buttonColor: Color(LabelColor.button.rawValue),
                        buttonLabelColor: Color(LabelColor.button.rawValue),
                        buttonBackgroundColor: Color(NavigationColor.button.rawValue)
                    )
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                .pressEvents {
                    withAnimation(.easeIn(duration: 0.1)) {
                        isPressed = true
                    }
                } onRelease: {
                    withAnimation {
                        isPressed = false
                    }
                }
                Spacer()
            }
            .navigationTitle(TabItem.help.rawValue.capitalized)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// 2
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
    
    @Environment(AlertModel.self) private var alert
    @State private var isPressed = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        VScrollView {
            VStack {
                ContentHeader(
                    titleLabel: HelpLabel.bugs,
                    logo: Logo.bugs,
                    logoColor: Color(OrnamentColor.logo.rawValue),
                    portraitSize: Squares.portrait.rawValue
                )
                Text("Reporting problems helps make \(Bundle.main.displayName!.capitalized) better. We will review it in order to have the issue resolved.")
                    .modifier(P(labelColor: Color(LabelColor.p.rawValue)))
                Spacer()
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
                        alert.showAlert(.mail, diagnostics: .noMailAccount)
                    }
                } label: {
                    ButtonLabelWithImage(
                        buttonImageName: Icon.mail.rawValue,
                        buttonTitle: ButtonTitle.report.rawValue.capitalized,
                        buttonColor: Color(LabelColor.button.rawValue),
                        buttonLabelColor: Color(LabelColor.button.rawValue),
                        buttonBackgroundColor: Color(NavigationColor.button.rawValue)
                    )
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                .alert(alert.topicTitle, isPresented: $showAlert) {
                    Button(ButtonTitle.ok.rawValue.capitalized) {
                    }
                } message: {
                    Text(alert.errorMessage)
                }
                .pressEvents {
                    withAnimation(.easeIn(duration: 0.1)) {
                        isPressed = true
                    }
                } onRelease: {
                    withAnimation {
                        isPressed = false
                    }
                }
                Spacer()
            }
            .navigationTitle(TabItem.help.rawValue.capitalized)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// 3
struct HelpAuthentication: View {
    
    @Environment(TabsModel.self) private var tabs
    
    var body: some View {
        VScrollView {
            VStack {
                ContentHeader(
                    titleLabel: HelpLabel.authentication,
                    logo: Logo.security,
                    logoColor: Color(OrnamentColor.logo.rawValue),
                    portraitSize: Squares.portrait.rawValue
                )
                Text("Login will grant our app \(Bundle.main.displayName!.capitalized), access to your Shopify merchant-data. Logout to revoke access.")
                    .modifier(P(labelColor: Color(LabelColor.p.rawValue)))
                Spacer()
                Button {
                    tabs.redirectTab = TabItem.shops
                } label: {
                    ButtonLabelWithImage(
                        buttonImageName: Icon.login.rawValue,
                        buttonTitle: ButtonTitle.login.rawValue.capitalized,
                        buttonColor: Color(LabelColor.button.rawValue),
                        buttonLabelColor: Color(LabelColor.button.rawValue),
                        buttonBackgroundColor: Color(NavigationColor.button.rawValue)
                    )
                }
                Spacer()
            }
            .navigationTitle(TabItem.help.rawValue.capitalized)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// 4
struct HelpRevoke: View {
    
    var body: some View {
        VScrollView {
            VStack {
                ContentHeader(
                    titleLabel: HelpLabel.revoke,
                    logo: Logo.security,
                    logoColor: Color(OrnamentColor.logo.rawValue),
                    portraitSize: Squares.portrait.rawValue
                )
                Group {
                    Text("To revoke your auto-renewable subscription, perform the following steps:\n\n1. Open the ") +
                    Text("**Settings** app on your iPhone\n\n2. Type **\"subscriptions\"**  in searchbar\n\n3. Find the subscription you want to ") +
                    Text("**cancel** and **tap** on it\n\n4. Tap **Cancel Subscription**. A confirmation message will appear\n")
                }
                .modifier(P(labelColor: Color(LabelColor.p.rawValue)))
                Spacer()
            }
            .navigationTitle(TabItem.help.rawValue.capitalized)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// 5
struct HelpCredits: View {
    var body: some View {
        VScrollView {
            VStack {
                ContentHeader(
                    titleLabel: HelpLabel.credits,
                    logo: Logo.credits,
                    logoColor: Color(OrnamentColor.logo.rawValue),
                    portraitSize: Squares.portrait.rawValue
                )
                Text("**AppAuth**\nOAuth2 technology. Copyright (c) 2016 William Denniss\n\n**ChatGPT**\nThis app uses insights generated by ChatGPT, developed by OpenAI.")
                    .modifier(P(labelColor: Color(LabelColor.p.rawValue)))
                Spacer()
            }
            .navigationTitle(TabItem.help.rawValue.capitalized)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct HelpView: View {
    
    var body: some View {
        ZStack {
            BackgroundView(
                watermarkImageName: Watermark.graph.rawValue,
                opacity: 0.05
            )
            TabView {
                HelpAbout()
                HelpBugs()
                HelpAuthentication()
                HelpRevoke()
                HelpCredits()
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .navigationTitle(TabItem.help.rawValue.capitalized)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
