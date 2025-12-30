//
//  ShopsView.swift
//  shops24
//
//  Created by Diederick de Buck on 10/12/2022.
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


enum ShopsLabel: String {
    case pickerTitle = "Select Shop"
    case empty = "No shops configured"
    case loggedIn = "Logged in"
    case loggedOut = "Logged out"
    case info = "Press + or - sign in the toolbar to add or remove a shop"
    case title = "Adding shops"
}


struct ShopsListView: View {
    
    @Environment(PortfolioModel.self) var portfolio
    @Environment(ColorManager.self) var colorManager
    @State private var selectedShop: String = ""
    
    var body: some View {
        VStack {
            Picker(ShopsLabel.pickerTitle.rawValue, selection: $selectedShop) {
                ForEach(portfolio.shops, id: \.self) { shop in
                    ShopListItem(
                        shopLabel: shop,
                        shopLabelColor: Color(LabelColor.picker.rawValue)
                    )
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
            .pickerStyle(WheelPickerStyle())
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(colorManager.stroke, lineWidth: 3)
            )
        }
    }
}


struct ShopsSyncView: View {
    
    @Environment(AlertModel.self) var alert
    @Environment(PortfolioModel.self) var portfolio
    @Environment(ConnectivityProvider.self) var watch
    @Environment(ColorManager.self) var colorManager

    @State private var isPressed: Bool = false
    @State private var showAlert: Bool = false
    
    @MainActor
    func syncWatch(connectivityProvider: ConnectivityProvider, portfolio: PortfolioModel) -> (Topic, Diagnostics) {
        if !portfolio.shopIsSelected(portfolio.selectedShop) {
            return (.shop, .unsubscribed)
        }
        /* REMOVED */
//        if !Security.isAuthorizedShop(portfolio.selectedShop) {
//            return (.security, .unauthorized)
//        }
        guard let result = Keychain.instance.getKeyChain(
            service: Bundle.main.displayName!,
            account: portfolio.selectedShop
        ) else {
            return (.security, .invalidAccessToken)
        }
        let accessToken = String(decoding: result, as: UTF8.self)
        let message = Shops42.shopAdd(portfolio.selectedShop, accessToken: accessToken)
        debugLog(accessToken)
        connectivityProvider.semaphore.wait()
        connectivityProvider.send(message: message)
        connectivityProvider.semaphore.signal()
        return (.none, .okay)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    let (topic, diagnostics) = self.syncWatch(
                        connectivityProvider: watch,
                        portfolio: portfolio
                    )
                    if (diagnostics != .okay) {
                        showAlert = true
                        Sound.playSound(
                            .reject,
                            soundExtension: .aif,
                            audible: UserDefaults.standard.bool(forKey: UDKey.sound.rawValue)
                        )
                        alert.showAlert(topic, diagnostics: diagnostics)
                        return
                    }
                } label: {
                    ButtonLabelWithImage(
                        buttonImageName: Icon.sync.rawValue,
                        buttonTitle: ButtonTitle.sync.rawValue.capitalized,
                        buttonColor: colorManager.navigationText,
                        buttonLabelColor: colorManager.navigationText,
                        buttonBackgroundColor: Color(NavigationColor.button.rawValue)
                    )
                }
            }
        }
        .alert(alert.topicTitle, isPresented: $showAlert) {
            Button(ButtonTitle.ok.rawValue.capitalized) {
            }
        } message: {
            Text(alert.errorMessage)
        }
    }
}

struct ShopsAuthView: View {
    @Environment(PortfolioModel.self) var portfolio
    @Environment(ColorManager.self) var colorManager
    @State private var isPressed = false
    var body: some View {
        VStack {
            HStack {
                NavigationLink(
                    destination:
                        AppAuthView()
                        .onAppear {
                            portfolio.selectShop(portfolio.selectedShop)
                        }
                ) {
                    ButtonLabelWithImage(
                        buttonImageName: Icon.login.rawValue,
                        buttonTitle: ButtonTitle.login.rawValue.capitalized,
                        buttonColor: colorManager.navigationText,
                        buttonLabelColor: colorManager.navigationText,
                        buttonBackgroundColor: Color(NavigationColor.button.rawValue)
                    )
                }

            }
        }
    }
}

struct ShopsNavigationView: View {
    @Environment(PortfolioModel.self) var portfolio

    
    @ViewBuilder
    func view(_ isAuthenticated: Bool) -> some View {
        switch isAuthenticated {
        case true: ShopsSyncView()
        default: ShopsAuthView()
        }
    }
    
    var body: some View {
        view(portfolio.securityState(portfolio.selectedShop) == .granted)
    }
}


struct ShopsConnectionView: View {
    @Environment(ConnectivityProvider.self) var watch
    var body: some View {
        VStack {
            ButtonLabelWithImage(
                buttonImageName: Icon.connection.rawValue,
                buttonTitle: watch.watchIsReady ? WatchState.connected.rawValue : WatchState.disconnected.rawValue,
                buttonColor: Utils.stateFieldColor(watch.watchIsReady ? .up : .down),
                buttonLabelColor: Color(LabelColor.p.rawValue),
                buttonBackgroundColor: .clear
            )
        }
    }
}


struct ShopsView: View {
    @Environment(PortfolioModel.self) var portfolio
    @Environment(ColorManager.self) var colorManager
    var body: some View {
        ZStack {
            colorManager.background.ignoresSafeArea()
            PageScrollView {
                VStack(spacing: 20) {
                    ContentHeader(
                        titleLabel: ShopsLabel.title.rawValue,
                        logo: TabIcon.shops.rawValue,
                        logoColor: colorManager.logo,
                        portraitSize: 60,
                        info: ShopsLabel.info.rawValue,
                    )
                    if portfolio.hasShops {
                        ShopsListView()
                    }
                    ShopsNavigationView()
                    ShopsConnectionView()
                }
            }
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        ShopView()
                            .onAppear {
                                Sound.playSound(
                                    .click,
                                    audible: UserDefaults.standard.bool(forKey: UDKey.sound.rawValue)
                                )
                            }
                    } label: {
                        Image(systemName: Icon.plus.rawValue)
                            .foregroundColor(colorManager.toolBarItems)
                    }
                }
                ToolbarItem {
                    Button {
                        Sound.playSound(
                            .trash,
                            soundExtension: .aif,
                            audible: UserDefaults.standard.bool(forKey: UDKey.sound.rawValue)
                        )
                        portfolio.delShop(portfolio.selectedShop)
                        _ = portfolio.selectFirstShop()
                    } label: {
                        Image(systemName: Icon.minus.rawValue)
                            .foregroundColor(colorManager.toolBarItems)
                    }
                }
            }
        }
    }
}

