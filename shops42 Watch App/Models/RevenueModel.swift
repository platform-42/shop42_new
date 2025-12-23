//
//  RevenueModel.swift
//  shops42 Watch App
//
//  Created by Diederick de Buck on 16/08/2024.
//

import Foundation
import P42_extensions
import P42_utils
import P42_watchos_widgets


struct RevenueItem: Codable, Identifiable {
    let id = UUID()
    var current_total_price: String
    var currency: String
    var financial_status: String

    private enum CodingKeys: String, CodingKey {
        case currency
        case current_total_price
        case financial_status
   }
}


struct RevenueResponse: Codable {
    var orders: [RevenueItem]
}


@Observable class RevenueModel {
    
    var revenue: [RevenueItem]
    var todayAmount: Double
    var todayAmountPending: Double
    var currency: String
    var lastUpdate: Date

    init() {
        self.todayAmount = 0.0
        self.todayAmountPending = 0.0
        self.revenue = []
        self.currency = Currency.eur.rawValue.capitalized
        self.lastUpdate = Date()
    }
    
    static func indicatorFieldLogic(_ amountPending: Double) -> WidgetStatus {
        return (amountPending > 0) ? .warning : .none
    }
    
    static func revenueTodayURL(shop: String, endpoint: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = ShopifyURIComponent.schema.rawValue
        components.host = "\(shop)\(ShopifyURIComponent.host.rawValue)"
        components.path = endpoint
        components.queryItems = [
            URLQueryItem(name: ShopifyTkn.status.rawValue, value: "any"),
            URLQueryItem(name: ShopifyTkn.created_at_min.rawValue, value: Date.ISOStringFromDate(Date().today)),
            URLQueryItem(name: ShopifyTkn.fields.rawValue, value: "\(ShopifyTkn.current_total_price.rawValue), \(ShopifyTkn.currency.rawValue),  \(ShopifyTkn.financial_status.rawValue)"),
            URLQueryItem(name: ShopifyTkn.limit.rawValue, value: String(100))
        ]
        return components
    }
    
    func revenueTodayHandler(response: Data, meta: Meta)  {
        meta.vsem(.nowait)
        guard let decoded = Json.fromJsonData(RevenueResponse.self, from: response) else {
            return
        }
        self.revenue = decoded.orders
        self.todayAmount = 0
        self.todayAmountPending = 0
        for order in self.revenue {
            self.todayAmount += Double(order.current_total_price)!
            if order.financial_status.lowercased() != "paid".lowercased() {
                self.todayAmountPending += Double(order.current_total_price)!
            }
            self.currency = order.currency
        }
        self.lastUpdate = Date()
    }
    
}
