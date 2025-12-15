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

enum TabIcon: String {
    case shops = "basket.fill"
    case logout = "rectangle.portrait.and.arrow.right.fill"
    case settings = "gearshape.2.fill"
    case help = "questionmark.circle.fill"
}

@Observable class TabsModel {
    var redirectTab: TabItem
    
    init(_ tabItem: TabItem) {
        self.redirectTab = tabItem
    }
}

