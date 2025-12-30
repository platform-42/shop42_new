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
import P42_colormanager


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
    
    @State private var udModel: UDModel = UDModel()
    @Environment(ColorManager.self) var colorManager
    @Environment(AlertModel.self) var alertModel
    @Environment(PortfolioModel.self) var portfolio
    @Environment(TabsModel.self) var tabsModel
    @Environment(ConnectivityProvider.self) var watch
    @State private var showAlert = false
    
    
    @MainActor func syncWatch(
        hasAutoSync: Bool,
        connectivityProvider: ConnectivityProvider,
        portfolio: PortfolioModel
    ) -> (Topic, Diagnostics) {
        if !hasAutoSync {
            return (.none, .okay)
        }
        /* REMOVED */
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
                    Toggle(isOn: $udModel.showHistory) {
                        Label(SettingsItem.history.rawValue, systemImage: Icon.history.rawValue)
                    }
                    Toggle(isOn: $udModel.showCustomers) {
                        Label(SettingsItem.customers.rawValue, systemImage: Icon.customers.rawValue)

                    }
                    Toggle(isOn: $udModel.showProducts) {
                        Label(SettingsItem.products.rawValue, systemImage: Icon.products.rawValue)
                    }
                } header: {
                    Text(SettingsSection.activity.rawValue.uppercased())
                        .font(.headline)
                }
                Section {
                    Toggle(isOn: $udModel.showAbandoned) {
                        Label(SettingsItem.abandoned.rawValue, systemImage: Icon.abandoned.rawValue)
                    }
                } header: {
                    Text(SettingsSection.alerts.rawValue.uppercased())
                        .font(.headline)
                }
                Section {
                    Toggle(isOn: $udModel.autoSync) {
                        Label(SettingsItem.autoSync.rawValue, systemImage: Icon.sync.rawValue)
                    }
                    Toggle(isOn: $udModel.sound) {
                        Label(SettingsItem.sound.rawValue, systemImage: Icon.soundOn.rawValue)
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

