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
import P42_screenelements
import P42_colormanager

enum LogoutLabel: String {
    case warning
    case info = "By pressing Logout, you will revoke access to Shopify merchant-data.\n\nIn order to use the Watch app again, you need to re-authenticate"
}

struct LogoutView: View {
    
    @Environment(AlertModel.self) var alertModel
    @Environment(PortfolioModel.self) var portfolio
    @Environment(ConnectivityProvider.self) var watch
    @Environment(TabsModel.self) var tabsModel
    @Environment(ColorManager.self) var colorManager
    @State private var showAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    
    var body: some View {
        ZStack {
            colorManager.background.ignoresSafeArea()
            PageScrollView {
                VStack(spacing: 20) {
                    ContentHeader(
                        titleLabel: LogoutLabel.warning.rawValue,
                        logo: Logo.warning.rawValue,
                        logoColor: colorManager.logo,
                        portraitSize: 60,
                        info: LogoutLabel.info.rawValue,
                    )
                    Button {
                        showDeleteAlert = (portfolio.selectedShop.isEmpty == false)
                        if (!showDeleteAlert) {
                            alertModel.showAlert(.shop, diagnostics: .unsubscribed)
                            Sound.playSound(
                                .reject,
                                soundExtension: .aif,
                                audible: UserDefaults.standard.bool(forKey: UDKey.sound.rawValue)
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
                    .padding(.top, 40)
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
                                audible: UserDefaults.standard.bool(forKey: UDKey.sound.rawValue)
                            )
                            Security.revokeObject(
                                portfolio.selectedShop,
                                applicationId: Bundle.main.bundleIdentifier!,
                                objectId: "shop"
                            )
                            portfolio.deselectShop(portfolio.selectedShop)
                            _ = portfolio.selectFirstShop()
                            tabsModel.select(.shops, isAuthenticated: true)
                        }
                    }
                }
            }
        }
    }
}


