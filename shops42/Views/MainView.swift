//
//  MainView.swift
//  shops24
//
//  Created by Diederick de Buck on 11/11/2022.
//

import SwiftUI
import P42_sound
import P42_utils

struct MainView: View {


    @State private var watch: ConnectivityProvider = ConnectivityProvider()
    @State private var portfolio: PortfolioModel = PortfolioModel()
    @State private var alert: AlertModel = AlertModel()
    @State private var tabsModel: TabsModel = TabsModel(TabItem.logout)
    let userDefaults: UD = UD()

    var body: some View {
        TabView(selection: $tabsModel.redirectTab) {
            ShopsView()
                .tabItem {
                    Label(
                        TabItem.shops.rawValue.capitalized,
                        systemImage: TabIcon.shops.rawValue
                    )
                }
                .tag(TabItem.shops)
                .environment(portfolio)
                .environment(watch)
                .environment(tabsModel)
                .environment(alert)

                .badge(Utils.showBadge(watch.isSyncing))
            LogoutView()
                .tabItem {
                    Label(
                        TabItem.logout.rawValue.capitalized,
                        systemImage: TabIcon.logout.rawValue
                    )
                }
                .tag(TabItem.logout)
                .environment(portfolio)
                .environment(watch)
                .environment(tabsModel)
                .environment(alert)
            SettingsView()
                .tabItem {
                    Label(
                        TabItem.settings.rawValue.capitalized,
                        systemImage: TabIcon.settings.rawValue
                    )
                }
                .tag(TabItem.settings)
                .environment(portfolio)
                .environment(watch)
                .environment(tabsModel)
                .environment(alert)
            HelpView()
                .tabItem {
                    Label(
                        TabItem.help.rawValue.capitalized,
                        systemImage: TabIcon.help.rawValue
                    )
                }
                .onAppear {
                    Sound.playSound(
                        .click,
                        audible: UserDefaults.standard.bool(forKey: UserDefaultsKey.sound.rawValue)
                    )
                }
                .tag(TabItem.help)
                .environment(tabsModel)
                .environment(alert)
        }
        .tint(Color(OrnamentColor.pagination.rawValue))
        .onAppear() {
            portfolio.restore()
        }
        .onChange(of: tabsModel.redirectTab) {
            Sound.playSound(
                .click,
                audible: UserDefaults.standard.bool(forKey: UserDefaultsKey.sound.rawValue)
            )
        }
    }
}
