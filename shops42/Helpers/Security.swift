//
//  Security.swift
//  shops24
//
//  Created by Diederick de Buck on 27/02/2023.
//

import Foundation
import P42_extensions
import P42_keychain

enum SecurityState {
    case prohibited
    case granted
}

class Security {
    
    static func authorizeShop(_ shop: String, secret: String) -> Bool {
        let shopName = PortfolioModel.shopName(shop)
        let service = Bundle.main.displayName!
        Keychain.instance.delFromKeyChain(
            service: service,
            account: shopName
        )
        let status = Keychain.instance.addToKeyChain(
            secret: Data(secret.utf8),
            service: service,
            account: shopName
        )
        UserDefaults.standard.set(shopName, forKey: UserDefaultsKey.selectedShop.rawValue)
        return (status == 0)
    }
    
    static func revokeShop(_ shop: String) {
        let shopName = PortfolioModel.shopName(shop)
        let service = Bundle.main.displayName!
        Keychain.instance.delFromKeyChain(
            service: service,
            account: shopName
        )
        UserDefaults.standard.set("", forKey: UserDefaultsKey.selectedShop.rawValue)
    }
    
    static func isAuthorizedShop(_ shop: String) -> Bool {
        let shopName = PortfolioModel.shopName(shop)
        if let _ = Keychain.instance.getKeyChain(
            service: Bundle.main.displayName!,
            account: shopName
        ) {
            return true
        }
        return false
    }
    
}
