//
//  UD.swift
//  shops24
//
//  Created by Diederick de Buck on 18/11/2022.
//

import Foundation
import P42_extensions

enum UserDefaultsKey: String {
    case orders
    case history
    case revenue
    case customers
    case products
    case abandoned
    case sound
    case selectedShop
    case shops
    case autoSync
    case hasLicense
    case initialized
    case renewalDate
}

class UD {
    
    static func defaults() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.orders.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.history.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.revenue.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.customers.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.products.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.abandoned.rawValue)
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.sound.rawValue)
        UserDefaults.standard.set("", forKey: UserDefaultsKey.selectedShop.rawValue)
        UserDefaults.standard.set([], forKey: UserDefaultsKey.shops.rawValue)
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.autoSync.rawValue)
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.hasLicense.rawValue)
        UserDefaults.standard.set(Date().toString(.date), forKey: UserDefaultsKey.renewalDate.rawValue)
    }
        
    init() {
        if UserDefaults.standard.object(forKey: UserDefaultsKey.initialized.rawValue) == nil {
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.initialized.rawValue)
        }
        if (!UserDefaults.standard.bool(forKey: UserDefaultsKey.initialized.rawValue)) {
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.initialized.rawValue)
            UD.defaults()
        }
    }
    
}
