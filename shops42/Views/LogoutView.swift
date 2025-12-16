//
//  LogoutView.swift
//  shops24
//
//  Created by Diederick de Buck on 11/11/2022.
//

import Foundation
import SwiftUI
import P42_extensions
import P42_keychain
import P42_sound
import P42_viewmodifiers
import P42_utils

enum LogoutTitle: String {
    case warning
}

struct LogoutView: View {
    
    @Environment(AlertModel.self) private var alertModel
    @Environment(PortfolioModel.self) private var portfolio
    @Environment(ConnectivityProvider.self) private var watch
    @Environment(TabsModel.self) private var tabsModel
    @Environment(ColorManager.self) var colorManager
    @State private var showAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    
    var body: some View {
        ZStack {
            BackgroundView(
                watermarkImageName: Watermark.graph.rawValue,
                opacity: 0.05
            )
            VStack {
                Spacer()
                Text(LogoutTitle.warning.rawValue.capitalized)
                    .modifier(H2(labelColor: Color(LabelColor.h2.rawValue)))
                Image(systemName: Logo.warning.rawValue)
                    .portrait(
                        width: Squares.portrait.rawValue,
                        height: Squares.portrait.rawValue
                    )
                    .foregroundColor(Utils.stateFieldColor(.neutral))
                Text("By pressing Logout, you will revoke access to Shopify merchant-data.\n\nIn order to use the Watch app again, you need to re-authenticate")
                    .modifier(P(labelColor: Color(LabelColor.p.rawValue)))
                Spacer()
                Button {
                    showDeleteAlert = (portfolio.selectedShop.isEmpty == false)
                    if (!showDeleteAlert) {
                        alertModel.showAlert(.shop, diagnostics: .unsubscribed)
                        Sound.playSound(
                            .reject,
                            soundExtension: .aif,
                            audible: UserDefaults.standard.bool(forKey: UserDefaultsKey.sound.rawValue)
                        )
                    }
                } label: {
                    ButtonLabelWithImage(
                        buttonImageName: Icon.trash.rawValue,
                        buttonTitle: ButtonTitle.logout.rawValue.capitalized,
                        buttonColor: colorManager.navigationText,
                        buttonLabelColor: colorManager.navigationText,
                        buttonBackgroundColor: colorManager.navigationBG
                    )
                }
                .alert(alertModel.topicTitle, isPresented: $showAlert) {
                    Button(ButtonTitle.ok.rawValue.capitalized) {
                        tabsModel.select(.shops, isAuthenticated: true)
                    }
                } message: {
                    Text(alertModel.errorMessage)
                }
                .alert("Remove access to \(portfolio.selectedShop)?", isPresented: $showDeleteAlert) {
                    Button(ButtonTitle.ok.rawValue.capitalized, role: .destructive) {
                        Sound.playSound(
                            .lock,
                            audible: UserDefaults.standard.bool(forKey: UserDefaultsKey.sound.rawValue)
                        )
                        Security.revokeShop(portfolio.selectedShop)
                        _ = portfolio.deselectShop(portfolio.selectedShop)
                        _ = portfolio.selectFirstShop()
                        tabsModel.select(.shops, isAuthenticated: true)
                    }
                }
                Spacer()
            }
            .navigationTitle(TabItem.logout.rawValue.capitalized)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


