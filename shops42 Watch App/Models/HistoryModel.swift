//
//  HistoryModel.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 19/04/2023.
//

import Foundation
import P42_utils
import P42_watchos_widgets


struct OrderItem: Codable, Identifiable {
    let id = UUID()
    var name: String
    var created_at: String
    var currency: String
    var current_total_price: String
    var financial_status: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case created_at
        case currency
        case current_total_price
        case financial_status
    }
}


struct OrderItemResponse: Codable {
    var orders: [OrderItem]
}


@Observable class HistoryModel {
    
    var ordersList: [OrderItem]
    var lastUpdate: Date

    init() {
        self.ordersList = []
        self.lastUpdate = Date()
    }

    static func indicatorFieldLogic(_ financialStatus: String) -> WidgetStatus {
        let status: String = financialStatus.lowercased()
        if status == "unpaid" || status == "partially_paid" || status == "partially_refundend" {
            return .alert
        }
        if status != "paid" {
            return .warning
        }
        return .none
    }
    
    static func historyLatestURL(shop: String, endpoint: String, limit: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = ShopifyURIComponent.schema.rawValue
        components.host = "\(shop)\(ShopifyURIComponent.host.rawValue)"
        components.path = endpoint
        components.queryItems = [
            URLQueryItem(name: ShopifyTkn.status.rawValue, value: "any"),
            URLQueryItem(name: ShopifyTkn.order.rawValue, value: "\(ShopifyTkn.created_at.rawValue) desc"),
            URLQueryItem(name: ShopifyTkn.fields.rawValue, value: "\(ShopifyTkn.name.rawValue),\(ShopifyTkn.currency.rawValue),\(ShopifyTkn.created_at.rawValue), \(ShopifyTkn.current_total_price.rawValue), \(ShopifyTkn.financial_status.rawValue)"),
            URLQueryItem(name: ShopifyTkn.limit.rawValue, value: String(limit))
        ]
        return components
    }
    
    func historyLatestHandler(response: Data, meta: Meta)  {
        meta.vsem(.nowait)
        guard let decoded = Json.fromJsonData(OrderItemResponse.self, from: response) else {
            return
        }
        self.ordersList = decoded.orders
        self.lastUpdate = Date()
    }
}
