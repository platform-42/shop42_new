//
//  Customers.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 19/04/2023.
//

import Foundation
import P42_extensions
import P42_utils
import P42_watchos_widgets


struct CustomersCount: Codable {
    var count: Int
}


@Observable class CustomersModel: ObservableObject {
    
    var today: Int
    var total: Int
    var lastUpdate: Date

    init() {
        self.today = 0
        self.total = 0
        self.lastUpdate = Date()
    }
    
    static func indicatorArrowLogic(customers: Int) -> WidgetState {
        if (customers > 0) {
            return .up
        }
        if (customers == 0) {
            return .neutral
        }
        return .down
    }
    
    static func customersTodayURL(shop: String, endpoint: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = ShopifyURIComponent.schema.rawValue
        components.host = "\(shop)\(ShopifyURIComponent.host.rawValue)"
        components.path = endpoint
        components.queryItems = [
            URLQueryItem(name: ShopifyTkn.created_at_min.rawValue, value: Date.ISOStringFromDate(Date().today))
        ]
        return components
    }
    
    static func customersTotalURL(shop: String, endpoint: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = ShopifyURIComponent.schema.rawValue
        components.host = "\(shop)\(ShopifyURIComponent.host.rawValue)"
        components.path = endpoint
        return components
    }
    
    func customersTodayHandler(response: Data, meta: Meta) {
        meta.vsem(.nowait)
        guard let decoded = Json.fromJsonData(CustomersCount.self, from: response) else {
            return
        }
        self.today = decoded.count
        self.lastUpdate = Date()
    }
    
    func customersTotalHandler(response: Data, meta: Meta) {
        meta.vsem(.nowait)
        guard let decoded = Json.fromJsonData(CustomersCount.self, from: response) else {
            return
        }
        self.total = decoded.count
        self.lastUpdate = Date()
    }
    
}
