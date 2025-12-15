//
//  Tabs.swift
//  shops24
//
//  Created by Diederick de Buck on 19/05/2023.
//

import Foundation

enum TabItem: String {
    case shops
    case logout
    case settings
    case help
}


enum TabSwitchResult {
    case success
    case notAuthenticated
}


@Observable
final class TabsModel {
    private(set) var selectedTab: TabItem

    init(_ tabItem: TabItem) {
        self.selectedTab = tabItem
    }

    @discardableResult
    func select(
        _ tab: TabItem,
        isAuthenticated: Bool
    ) -> TabSwitchResult {
        switch tab {
//        case .properties where !isAuthenticated:
//            return .notAuthenticated
        default:
            selectedTab = tab
            return .success
        }
    }
}


