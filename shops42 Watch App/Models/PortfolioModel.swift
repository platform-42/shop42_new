//
//  Portfolio.swift
//  shops24
//
//  Created by Diederick de Buck on 03/03/2023.
//

import Foundation


final class PortfolioModel: ObservableObject {
    
    @Published private(set) var selectedShop: String
    @Published private(set) var selectedViews: [WatchView]
    @Published private(set) var numberOfViews: Int
    @Published var licenseCheck: Bool
    var accessToken: String
    
    static let instance = PortfolioModel()
    
    private init() {
        self.selectedShop = ""
        self.accessToken = ""
        self.selectedViews = []
        self.numberOfViews = 0
        self.licenseCheck = false
    }
    
    func shopIsSelected(_ shop: String) -> Bool {
        return (shop.caseInsensitiveCompare(self.selectedShop) == .orderedSame)
    }
    
    private func updateShop(_ shop: String, views: [String : Bool]) {
        if self.shopIsSelected(shop) {
            self.selectedViews = []
            self.numberOfViews = 0
            for (key, value) in views {
                if value {
                    let viewEnum = WatchView(rawValue: key)!
                    selectedViews.append(viewEnum)
                    self.numberOfViews += 1
                }
            }
        }
    }
    
    func addShop(_ shop: String, accessToken: String, views: [String : Bool]) {
        if !self.shopIsSelected(shop) {
            self.selectedShop = shop.lowercased()
            self.accessToken = accessToken
        }
        self.updateShop(
            shop,
            views: views
        )
    }
    
    func destroy() {
        self.selectedShop = ""
        self.accessToken = ""
        self.selectedViews = []
        self.numberOfViews = 0
        self.licenseCheck = false
    }
}
