//
//  Portfolio.swift
//  shops24
//
//  Created by Diederick de Buck on 03/03/2023.
//

import Foundation
import P42_keychain


@Observable class PortfolioModel {
    
    private(set) var shops: [String]
    private(set) var numberOfShops: Int
    private(set) var selectedShop: String
    
    var hasShops: Bool {
        !self.shops.isEmpty
    }

    init() {
        self.selectedShop = ""
        self.shops = []
        self.numberOfShops = 0
    }
    
    func restore() {
        let selectedShop = UserDefaults.standard.string(forKey: UDKey.selectedShop.rawValue)!
        let shops = (UserDefaults.standard.array(forKey: UDKey.shops.rawValue) as? [String])!
        let numberOfShops = (UserDefaults.standard.array(forKey: UDKey.shops.rawValue))!.count
        self.selectedShop = PortfolioModel.shopName(selectedShop)
        self.shops = shops
        self.numberOfShops = numberOfShops
    }
    
    static func shopName(_ shop: String) -> String {
        return shop.lowercased().removePostfix(ShopifyURIComponent.host.rawValue)
    }
    
    func shopIsSelected(_ shop: String) -> Bool {
        let shopName = PortfolioModel.shopName(shop)
        return (shopName == self.selectedShop) && (self.selectedShop.count != 0)
    }
    
    func securityState(_ shop: String) -> SecurityState {
        let shopName = PortfolioModel.shopName(shop)
        if let _ = Keychain.instance.getKeyChain(
            service: Bundle.main.displayName!,
            account: shopName
        ) {
            return .granted
        }
        
        return .prohibited
    }
    
    static func securityIcon(_ securityState: SecurityState) -> IconSecurity {
        return (securityState == .granted) ? .granted : .prohibited
    }
    
    @discardableResult
    func selectFirstShop() -> Bool {
        if (self.shops.count != 0) {
            self.selectedShop = PortfolioModel.shopName(shops.first!)
            UserDefaults.standard.set(
                self.selectedShop,
                forKey: UDKey.selectedShop.rawValue
            )
            return true
        }
        return false
    }
    
    @discardableResult
    func selectShop(_ shop: String) -> Bool {
        let shopName = PortfolioModel.shopName(shop)
        if self.shops.contains(where: { $0 == shopName }) {
            self.selectedShop = shopName
            UserDefaults.standard.set(
                self.selectedShop,
                forKey: UDKey.selectedShop.rawValue
            )
            return true
        }
        return false
    }
    
    @discardableResult
    func deselectShop(_ shop: String) -> Bool {
        if shopIsSelected(shop) {
            self.selectedShop = ""
            UserDefaults.standard.set(
                self.selectedShop,
                forKey: UDKey.selectedShop.rawValue
            )
            return true
        }
        return false
    }
    
    func addShop(_ shop: String) -> Bool {
        let shopName = PortfolioModel.shopName(shop)
        if self.shops.contains(where: { $0 == shopName }) {
            return true
        }
        self.shops.append(shopName)
        self.numberOfShops = shops.count
        UserDefaults.standard.set(
            self.shops,
            forKey: UDKey.shops.rawValue
        )
        return true
    }
    
    @discardableResult
    func delShop(_ shop: String) -> Bool {
        let shopName = PortfolioModel.shopName(shop)
        self.shops.removeAll { $0 == shopName }
        UserDefaults.standard.set(
            self.shops,
            forKey: UDKey.shops.rawValue
        )
        self.numberOfShops = self.shops.count
        return self.deselectShop(shopName)
    }
}
