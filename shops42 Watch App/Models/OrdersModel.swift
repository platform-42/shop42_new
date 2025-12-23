//
//  Orders.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 19/04/2023.
//

import Foundation
import P42_extensions
import P42_utils
import P42_watchos_widgets


struct OrdersCount: Codable {
    var count: Int
}


@Observable class OrdersModel {
    
    var today: Int
    var todayPending: Int
    var lastUpdate: Date

    init() {
        self.today = 0
        self.todayPending = 0
        self.lastUpdate = Date()
    }
    
    static func indicatorFieldlogic(_ ordersPending: Int) -> WidgetStatus {
        return (ordersPending > 0) ? .warning : .none
    }
    
    static func ordersTodayURL(shop: String, endpoint: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = ShopifyURIComponent.schema.rawValue
        components.host = "\(shop)\(ShopifyURIComponent.host.rawValue)"
        components.path = endpoint
        components.queryItems = [
            URLQueryItem(name: ShopifyTkn.status.rawValue, value: "any"),
            URLQueryItem(name: ShopifyTkn.created_at_min.rawValue, value: Date.ISOStringFromDate(Date().today))
        ]
        return components
    }
    
    static func ordersTodayPendingURL(shop: String, endpoint: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = ShopifyURIComponent.schema.rawValue
        components.host = "\(shop)\(ShopifyURIComponent.host.rawValue)"
        components.path = endpoint
        components.queryItems = [
            URLQueryItem(name: ShopifyTkn.created_at_min.rawValue, value: Date.ISOStringFromDate(Date().today)),
            URLQueryItem(name: ShopifyTkn.financial_status.rawValue, value: "pending")
        ]
        return components
    }
    
    func ordersTodayHandler(response: Data, meta: Meta) {
        meta.vsem(.nowait)
        guard let decoded = Json.fromJsonData(OrdersCount.self, from: response) else {
            return
        }
        self.today = decoded.count
        self.lastUpdate = Date()
    }
    
    func ordersTodayPendingHandler(response: Data, meta: Meta) {
        meta.vsem(.nowait)
        guard let decoded = Json.fromJsonData(OrdersCount.self, from: response) else {
            return
        }
        self.todayPending = decoded.count
        self.lastUpdate = Date()
    }
}
