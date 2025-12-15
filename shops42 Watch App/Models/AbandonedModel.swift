//
//  Abandoned.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 25/04/2023.
//

import Foundation
import P42_extensions
import P42_utils
import P42_watchos_widgets


struct AbandonedItem: Codable, Identifiable {
    let id = UUID()
    var total_price: String
    var currency: String
    
    private enum CodingKeys: String, CodingKey {
        case total_price
        case currency
    }
}


struct AbandonedResponse: Codable {
    var checkouts: [AbandonedItem]
}


@Observable class AbandonedModel {
    
    var today: Int
    var todayTotal: Double
    var currency: String
    var abandoned: [AbandonedItem]
    
    init() {
        self.today = 0
        self.todayTotal = 0.0
        self.currency = Currency.eur.rawValue.capitalized
        self.abandoned = []
    }
    
    static func indicatorFieldlogic(_ abandoned: Int) -> WidgetStatus {
        return (abandoned > 0) ? .alert : .none
    }
    
    static func abandonedTodayURL(shop: String, endpoint: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = ShopifyURIComponent.schema.rawValue
        components.host = "\(shop)\(ShopifyURIComponent.host.rawValue)"
        components.path = endpoint
        components.queryItems = [
            URLQueryItem(name: ShopifyTkn.created_at_min.rawValue, value: Date.ISOStringFromDate(Date().today))
        ]
        return components
    }
 
    func abandonedTodayHandler(response: Data, meta: Meta)  {
        meta.vsem(.nowait)
        guard let decoded = Json.fromJsonData(AbandonedResponse.self, from: response) else {
            return
        }
        self.abandoned = decoded.checkouts
        self.today = 0
        self.todayTotal = 0.0
        for checkout in self.abandoned {
            self.today += 1
            self.todayTotal += Double(checkout.total_price)!
            self.currency = checkout.currency
        }
    }
    
}
