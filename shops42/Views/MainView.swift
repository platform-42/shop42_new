//
//  MainView.swift
//  shops24
//
//  Created by Diederick de Buck on 11/11/2022.
//

import SwiftUI
import P42_sound
import P42_utils
import P42_colormanager

enum AppTab: String, CaseIterable, Identifiable {
    case shops
    case logout
    case settings
    case help
    
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
    var icon: String {
        switch self {
        case .shops: return TabIcon.shops.rawValue
        case .logout: return TabIcon.logout.rawValue
        case .settings: return TabIcon.settings.rawValue
        case .help: return TabIcon.help.rawValue
        }
    }
}


@ViewBuilder
func tabContent(_ tab: AppTab) -> some View {
    switch tab {
    case .shops: ShopsView()
    case .logout: LogoutView()
    case .settings: SettingsView()
    case .help: HelpView()
    }
}


struct TabContainer<Content: View>: View {
    let title: String
    let content: () -> Content

    var body: some View {
        NavigationStack {
            content()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.large)
        }
    }
}


struct MainView: View {
    
    func forceRedraw() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.rootViewController?.view.setNeedsLayout()
                window.rootViewController?.view.setNeedsDisplay()
            }
        }
    }
    
    func updateColorScheme(
        _ colorScheme: ColorScheme,
        colorManager: ColorManager
    ) {
        colorManager.updateColorScheme(colorScheme)
        let tint = UIColor(colorManager.tint)
        UIPageControl.appearance().currentPageIndicatorTintColor = tint
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(colorManager.tabBarBG)
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        forceRedraw()
    }
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(ColorManager.self) var colorManager
    @EnvironmentObject var udModel: UDModel
    @State private var watch: ConnectivityProvider = ConnectivityProvider()
    @State private var portfolioModel: PortfolioModel
    @State private var alertModel: AlertModel = AlertModel()
    @State private var tabsModel: TabsModel = TabsModel(TabItem.logout)
    @State private var showAlert: Bool = false

    init(udModel: UDModel) {
        _portfolioModel = State(initialValue: PortfolioModel(udModel: udModel))
    }
    
    private var tabSelectionBinding: Binding<AppTab> {
        Binding(
            get: {
                AppTab(rawValue: tabsModel.selectedTab.rawValue)!
            },
            set: { newTab in
                let result = tabsModel.select(
                    TabItem(rawValue: newTab.rawValue)!,
                    isAuthenticated: true
                )

                if result == .notAuthenticated {
 //                   showAlert = alertModel.showAlert(
 //                       .security,
 //                       alertDiagnostics: .notAuthenticated
 //                   )
                }
            }
        )
    }
    
    var body: some View {
        ZStack {
            colorManager.background.ignoresSafeArea()
            TabView(selection: tabSelectionBinding) {
                ForEach(AppTab.allCases) { tab in
                    TabContainer(title: tab.title) {
                        tabContent(tab)
                    }
                    .tabItem {
                        Label(tab.title, systemImage: tab.icon)
                    }
                    .tag(tab)
                }
            }
            .tint(colorManager.tint)
            .onAppear() {
                updateColorScheme(colorScheme, colorManager: colorManager)
            }
            .onChange(of: colorScheme) { oldValue, newValue in
                updateColorScheme(newValue, colorManager: colorManager)
            }
        }
        .environment(colorManager)
        .environment(watch)
        .environment(alertModel)
        .environment(portfolioModel)
        .environment(tabsModel)
    }
}
