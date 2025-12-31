//
//  SettingsModel.swift
//  shops24
//
//  Created by Diederick de Buck on 03/03/2023.
//

import Foundation


final class UDModel: ObservableObject {
    
    @Published var showOrders: Bool {
        didSet {
            UserDefaults.standard.set(showOrders, forKey: UDKey.orders.rawValue)
        }
    }
    @Published var showHistory: Bool {
        didSet {
            UserDefaults.standard.set(showHistory, forKey: UDKey.history.rawValue)
        }
    }
    @Published var showRevenue: Bool {
        didSet {
            UserDefaults.standard.set(showRevenue, forKey: UDKey.revenue.rawValue)
        }
    }
    @Published var showCustomers: Bool {
        didSet {
            UserDefaults.standard.set(showCustomers, forKey: UDKey.customers.rawValue)
        }
    }
    @Published var showProducts: Bool {
        didSet {
            UserDefaults.standard.set(showProducts, forKey: UDKey.products.rawValue)
        }
    }
    @Published var showAbandoned: Bool {
        didSet {
            UserDefaults.standard.set(showAbandoned, forKey: UDKey.abandoned.rawValue)
        }
    }
    @Published var sound: Bool {
        didSet {
            UserDefaults.standard.set(sound, forKey: UDKey.sound.rawValue)
        }
    }
    @Published var autoSync: Bool {
        didSet {
            UserDefaults.standard.set(autoSync, forKey: UDKey.autoSync.rawValue)
        }
    }
    @Published var shops: [String] {
        didSet {
            UserDefaults.standard.set(shops, forKey: UDKey.shops.rawValue)
        }
    }
    @Published var selectedShop: String {
        didSet {
            UserDefaults.standard.set(selectedShop, forKey: UDKey.selectedShop.rawValue)
        }
    }
    
    func isEnabled(
        _ view: WatchView
    ) -> Bool {
        switch view {
        case .orders: showOrders
        case .history: showHistory
        case .revenue: showRevenue
        case .customers: showCustomers
        case .products: showProducts
        case .abandoned: showAbandoned
        }
    }

    var enabledViews: [WatchView] {
        WatchView.allCases
            .filter(isEnabled)
            .sorted()
    }
    
    init() {
        debugLog("\(String(describing: type(of: self))).\(#function)")
        UserDefaults.standard.register(defaults: [
            UDKey.orders.rawValue: true,
            UDKey.history.rawValue: true,
            UDKey.revenue.rawValue: true,
            UDKey.customers.rawValue: true,
            UDKey.products.rawValue: true,
            UDKey.abandoned.rawValue: true,
            UDKey.sound.rawValue: false,
            UDKey.autoSync.rawValue: false,
            UDKey.shops.rawValue: [],
            UDKey.selectedShop.rawValue: ""
            ]
        )
        self.showOrders = UserDefaults.standard.bool(forKey: UDKey.orders.rawValue)
        self.showHistory = UserDefaults.standard.bool(forKey: UDKey.history.rawValue)
        self.showRevenue = UserDefaults.standard.bool(forKey: UDKey.revenue.rawValue)
        self.showCustomers = UserDefaults.standard.bool(forKey: UDKey.customers.rawValue)
        self.showProducts = UserDefaults.standard.bool(forKey: UDKey.products.rawValue)
        self.showAbandoned = UserDefaults.standard.bool(forKey: UDKey.abandoned.rawValue)
        self.sound = UserDefaults.standard.bool(forKey: UDKey.sound.rawValue)
        self.autoSync = UserDefaults.standard.bool(forKey: UDKey.autoSync.rawValue)
        self.shops = UserDefaults.standard.stringArray(forKey: UDKey.shops.rawValue) ?? []
        self.selectedShop = UserDefaults.standard.string(forKey: UDKey.selectedShop.rawValue) ?? ""
    }
    
    func reset() {
        debugLog("\(String(describing: type(of: self))).\(#function)")
        self.showOrders = true
        self.showHistory = true
        self.showRevenue = true
        self.showCustomers = true
        self.showProducts = true
        self.showAbandoned = true
        self.sound = false
        self.autoSync = false
        self.shops.removeAll()
        self.selectedShop = ""
    }
    
}
