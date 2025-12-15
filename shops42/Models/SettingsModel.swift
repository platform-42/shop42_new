//
//  SettingsModel.swift
//  shops24
//
//  Created by Diederick de Buck on 03/03/2023.
//

import Foundation


@Observable class SettingsModel {
    
    var showOrders: Bool
    var showHistory: Bool
    var showRevenue: Bool
    var showCustomers: Bool
    var showProducts: Bool
    var showAbandoned: Bool
    var sound: Bool
    var autoSync: Bool
    
    init() {
        self.showOrders = UserDefaults.standard.bool(forKey: UserDefaultsKey.orders.rawValue)
        self.showHistory = UserDefaults.standard.bool(forKey: UserDefaultsKey.history.rawValue)
        self.showRevenue = UserDefaults.standard.bool(forKey: UserDefaultsKey.revenue.rawValue)
        self.showCustomers = UserDefaults.standard.bool(forKey: UserDefaultsKey.customers.rawValue)
        self.showProducts = UserDefaults.standard.bool(forKey: UserDefaultsKey.products.rawValue)
        self.showAbandoned = UserDefaults.standard.bool(forKey: UserDefaultsKey.abandoned.rawValue)
        self.sound = UserDefaults.standard.bool(forKey: UserDefaultsKey.sound.rawValue)
        self.autoSync = UserDefaults.standard.bool(forKey: UserDefaultsKey.autoSync.rawValue)
    }
    
}
