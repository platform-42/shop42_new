//
//  Json.swift
//  shops24
//
//  Created by Diederick de Buck on 18/12/2022.
//

import Foundation

enum Shops42TKN: String {
    case operation
    case access_token
    case shop
    case orders
    case history
    case revenue
    case customers
    case abandoned
    case products
    case views
    case status
}


class Shops42 {
        
    static func shopAdd(_ shop: String, accessToken: String) -> [String : Any] {
        let views: [String : Any] = [
            Shops42TKN.orders.rawValue: UserDefaults.standard.bool(forKey: UDKey.orders.rawValue),
            Shops42TKN.history.rawValue: UserDefaults.standard.bool(forKey: UDKey.history.rawValue),
            Shops42TKN.revenue.rawValue: UserDefaults.standard.bool(forKey: UDKey.revenue.rawValue),
            Shops42TKN.customers.rawValue: UserDefaults.standard.bool(forKey: UDKey.customers.rawValue),
            Shops42TKN.products.rawValue: UserDefaults.standard.bool(forKey: UDKey.products.rawValue),
            Shops42TKN.abandoned.rawValue: UserDefaults.standard.bool(forKey: UDKey.abandoned.rawValue)
        ]
        let body: [String : Any] = [
            Shops42TKN.access_token.rawValue: accessToken,
            Shops42TKN.shop.rawValue: shop,
            Shops42TKN.views.rawValue: views,
        ]
        return body
    }
    

}
