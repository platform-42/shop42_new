//
//  Portfolio.swift
//  shops24
//
//  Created by Diederick de Buck on 03/03/2023.
//

import Foundation
import P42_keychain


@Observable
class PortfolioModel {
    
    private let udModel: UDModel
    
    var shops: [String] {
        udModel.shops
    }
    
    var numberOfShops: Int {
        udModel.shops.count
    }
    
    var selectedShop: String {
        udModel.selectedShop
    }
    
    init(udModel: UDModel) {
        self.udModel = udModel
    }
    
    var hasShops: Bool {
        !self.shops.isEmpty
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
            udModel.selectedShop = PortfolioModel.shopName(shops.first!)
            return true
        }
        return false
    }
    
    @discardableResult
    func selectShop(_ shop: String) -> Bool {
        let shopName = PortfolioModel.shopName(shop)
        if self.shops.contains(where: { $0 == shopName }) {
            udModel.selectedShop = shopName
            return true
        }
        return false
    }
    
    @discardableResult
    func deselectShop(_ shop: String) -> Bool {
        if shopIsSelected(shop) {
            udModel.selectedShop = ""
            return true
        }
        return false
    }
    
    func addShop(_ shop: String) -> Bool {
        let shopName = PortfolioModel.shopName(shop)
        if self.shops.contains(where: { $0 == shopName }) {
            return false
        }
        udModel.shops.append(shopName)
        return true
    }
    
    @discardableResult
    func delShop(_ shop: String) -> Bool {
        let shopName = PortfolioModel.shopName(shop)
        udModel.shops.removeAll { $0 == shopName }
        return self.deselectShop(shopName)
    }
}
