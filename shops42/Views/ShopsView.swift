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
}


struct ShopsListView: View {
    
    @Environment(PortfolioModel.self) var portfolio
    @State private var selectedShop: String = ""
    @State private var icon: String = ""
    @State private var granted: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Picker(ShopsLabel.pickerTitle.rawValue, selection: $selectedShop) {
                ForEach(portfolio.shops, id: \.self) { shop in
                    ShopListItem(
                        shopLabel: shop,
                        shopLabelColor: Color(LabelColor.picker.rawValue)
                    )
                }
            }
            .onAppear {
                selectedShop = portfolio.selectedShop
                portfolio.selectShop(selectedShop)
                icon = PortfolioModel.securityIcon(portfolio.securityState(portfolio.selectedShop)).rawValue
                granted = portfolio.securityState(portfolio.selectedShop) == .granted
            }
            .onChange(of: selectedShop) { _, changed in
                portfolio.selectShop(changed)
                icon = PortfolioModel.securityIcon(portfolio.securityState(changed)).rawValue
                granted = portfolio.securityState(changed) == .granted
            }
            .pickerStyle(.inline)
            Image(systemName: icon)
                .portrait(
                    width: Squares.portrait.rawValue,
                    height: Squares.portrait.rawValue
                )
            Text(granted ? ShopsLabel.loggedIn.rawValue : ShopsLabel.loggedOut.rawValue)
            Spacer()
        }
    }
}


struct ShopsSyncView: View {
    
    @Environment(AlertModel.self) var alert
    @Environment(PortfolioModel.self) var portfolio
    @Environment(ConnectivityProvider.self) var watch
    
    @State private var isPressed: Bool = false
    @State private var showAlert: Bool = false
    
    @MainActor
    func syncWatch(connectivityProvider: ConnectivityProvider, portfolio: PortfolioModel) -> (Topic, Diagnostics) {
        if !UserDefaults.standard.bool(forKey: UserDefaultsKey.hasLicense.rawValue) {
            return (.license, .unlicensed)
        }
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
                            audible: UserDefaults.standard.bool(forKey: UserDefaultsKey.sound.rawValue)
                        )
                        alert.showAlert(topic, diagnostics: diagnostics)
                        return
                    }
                } label: {
                    ButtonLabelWithImage(
                        buttonImageName: Icon.sync.rawValue,
                        buttonTitle: ButtonTitle.sync.rawValue.capitalized,
                        buttonColor: Color(LabelColor.button.rawValue),
                        buttonLabelColor: Color(LabelColor.button.rawValue),
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
                        buttonColor: Color(LabelColor.button.rawValue),
                        buttonLabelColor: Color(LabelColor.button.rawValue),
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
                    ShopsListView()
                    ShopsNavigationView()
                    ShopsConnectionView()
                        .padding(.bottom, 100)
                }
            }
            .modifier(
                EmptyDataModifier(
                    items: portfolio.shops,
                    placeholder:
                        Label(ShopsLabel.empty.rawValue, systemImage: Icon.orders.rawValue)
                        .labelStyle(BackgroundLabelStyle(
                            color: colorManager.navigationText,
                            backgroundColor: colorManager.navigationBG,
                            radius: 25.0
                        )
                        )
                )
            )
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        ShopView()
                            .onAppear {
                                Sound.playSound(
                                    .click,
                                    audible: UserDefaults.standard.bool(forKey: UserDefaultsKey.sound.rawValue)
                                )
                            }
                    } label: {
                        Image(systemName: Icon.plus.rawValue)
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem {
                    Button {
                        Sound.playSound(
                            .trash,
                            soundExtension: .aif,
                            audible: UserDefaults.standard.bool(forKey: UserDefaultsKey.sound.rawValue)
                        )
                        portfolio.delShop(portfolio.selectedShop)
                        _ = portfolio.selectFirstShop()
                    } label: {
                        Image(systemName: Icon.minus.rawValue)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

