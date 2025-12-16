//
//  SettingsView.swift
//  shops24
//
//  Created by Diederick de Buck on 11/11/2022.
//

import Foundation
import SwiftUI
import P42_keychain
import P42_sound

enum SettingsSection: String {
    case activity
    case alerts
    case limits
    case controls
}

enum SettingsItem: String {
    case orders = "Show Orders"
    case history = "Show Orders History"
    case revenue = "Show Revenue"
    case customers = "Show Customers"
    case products = "Show Products"
    case abandoned = "Abandoned Carts"
    case sound = "Sound"
    case autoSync = "Auto Sync"
}

struct SettingsView: View {
    
    @State private var settingsModel: SettingsModel = SettingsModel()
    @Environment(ColorManager.self) private var colorManager
    @Environment(AlertModel.self) private var alertModel
    @Environment(PortfolioModel.self) private var portfolio
    @Environment(TabsModel.self) private var tabsModel
    @Environment(ConnectivityProvider.self) private var watch
    @State private var showAlert = false
    
    @MainActor
    func onChangeHandler(_ newValue: Bool, settingsKey: UserDefaultsKey) -> Void {
        UserDefaults.standard.set(newValue, forKey: settingsKey.rawValue)
        Sound.playSound(
            .click,
            audible: UserDefaults.standard.bool(forKey: UserDefaultsKey.sound.rawValue)
        )
        let (topic, diagnostics) = syncWatch(
            hasAutoSync: settingsModel.autoSync,
            connectivityProvider: watch,
            portfolio: portfolio
        )
        if (diagnostics != .okay) {
            alertModel.showAlert(topic, diagnostics: diagnostics)
        }
    }
    
    
    @MainActor func syncWatch(hasAutoSync: Bool, connectivityProvider: ConnectivityProvider, portfolio: PortfolioModel) -> (Topic, Diagnostics) {
        if !hasAutoSync {
            return (.none, .okay)
        }
        if !UserDefaults.standard.bool(forKey: UserDefaultsKey.hasLicense.rawValue) {
            return (.license, .unlicensed)
        }
        if !Security.isAuthorizedShop(portfolio.selectedShop) {
            return  (.security, .unauthorized)
        }
        guard let result = Keychain.instance.getKeyChain(
            service: Bundle.main.displayName!,
            account: portfolio.selectedShop
        ) else {
            return (.security, .invalidAccessToken)
        }
        let accessToken = String(decoding: result, as: UTF8.self)
        let message = Shops42.shopAdd(
            portfolio.selectedShop,
            accessToken: accessToken
        )
        connectivityProvider.semaphore.wait()
        connectivityProvider.send(message: message)
        connectivityProvider.semaphore.signal()
        return (.none, .okay)
    }
    
    var body: some View {
        ZStack {
            colorManager.background.ignoresSafeArea()
            List {
                Section {
                    Toggle(isOn: $settingsModel.showHistory) {
                        SettingsLabel(
                            label: SettingsItem.history.rawValue,
                            icon: Icon.history,
                            iconColor: IconColor.history
                        )
                    }
                    .onChange(of: settingsModel.showHistory) { _, changed in
                        onChangeHandler(changed, settingsKey: .history)
                    }
                    Toggle(isOn: $settingsModel.showCustomers) {
                        SettingsLabel(
                            label: SettingsItem.customers.rawValue,
                            icon: Icon.customers,
                            iconColor: IconColor.customers
                        )
                    }
                    .onChange(of: settingsModel.showCustomers) { _, changed in
                        onChangeHandler(changed, settingsKey: .customers)
                    }
                    Toggle(isOn: $settingsModel.showProducts) {
                        SettingsLabel(
                            label: SettingsItem.products.rawValue,
                            icon: Icon.products,
                            iconColor: IconColor.products
                        )
                    }
                    .onChange(of: settingsModel.showProducts) { _, changed in
                        onChangeHandler(changed, settingsKey: .products)
                    }
                } header: {
                    Text(SettingsSection.activity.rawValue.uppercased())
                        .font(.headline)
                }
                Section {
                    Toggle(isOn: $settingsModel.showAbandoned) {
                        SettingsLabel(
                            label: SettingsItem.abandoned.rawValue,
                            icon: Icon.abandoned,
                            iconColor: IconColor.abandoned
                        )
                    }
                    .onChange(of: settingsModel.showAbandoned) { _, changed in
                        onChangeHandler(changed, settingsKey: .abandoned)
                    }
                } header: {
                    Text(SettingsSection.alerts.rawValue.uppercased())
                        .font(.headline)
                }
                Section {
                    Toggle(isOn: $settingsModel.autoSync) {
                        SettingsLabel(
                            label: SettingsItem.autoSync.rawValue,
                            icon: Icon.sync,
                            iconColor: IconColor.autosync
                        )
                    }
                    .onChange(of: settingsModel.autoSync) { _, changed in
                        onChangeHandler(changed, settingsKey: .autoSync)
                    }
                    Toggle(isOn: $settingsModel.sound) {
                        SettingsLabel(
                            label: SettingsItem.sound.rawValue,
                            icon: Icon.soundOn,
                            iconColor: IconColor.sound
                        )
                    }
                    .onChange(of: settingsModel.sound) { _, changed in
                        onChangeHandler(changed, settingsKey: .sound)
                    }
                } header: {
                    Text(SettingsSection.controls.rawValue.uppercased())
                        .font(.headline)
                }
            }
            .alert(alertModel.topicTitle, isPresented: $showAlert) {
                Button(ButtonTitle.ok.rawValue.capitalized) {
                    tabsModel.select(.shops, isAuthenticated: true)
                }
            } message: {
                Text(alertModel.errorMessage)
            }
            .scrollContentBackground(.hidden)
        }
    }
}

