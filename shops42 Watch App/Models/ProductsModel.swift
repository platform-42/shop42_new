//
//  Products.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 25/04/2023.
//

import Foundation
import P42_extensions
import P42_utils
import P42_watchos_widgets


struct ProductsCount: Codable {
    var count: Int
}


@Observable class ProductsModel {
    
    var today: Int
    var total: Int
    var lastUpdate: Date

    init() {
        self.today = 0
        self.total = 0
        self.lastUpdate = Date()
    }
    
    static func indicatorArrowLogic(products: Int) -> WidgetState {
        if (products > 0) {
            return .up
        }
        if (products == 0) {
            return .neutral
        }
        return .down
    }
    
    static func productsTodayURL(shop: String, endpoint: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = ShopifyURIComponent.schema.rawValue
        components.host = "\(shop)\(ShopifyURIComponent.host.rawValue)"
        components.path = endpoint
        components.queryItems = [
            URLQueryItem(name: ShopifyTkn.created_at_min.rawValue, value: Date.ISOStringFromDate(Date().today))
        ]
        return components
    }
    
    static func productsTotalURL(shop: String, endpoint: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = ShopifyURIComponent.schema.rawValue
        components.host = "\(shop)\(ShopifyURIComponent.host.rawValue)"
        components.path = endpoint
        return components
    }
    
    func productsTodayHandler(response: Data, meta: Meta) {
        meta.vsem(.nowait)
        guard let decoded = Json.fromJsonData(ProductsCount.self, from: response) else {
            return
        }
        self.today = decoded.count
        self.lastUpdate = Date()
    }

    func productsTotalHandler(response: Data, meta: Meta) {
        meta.vsem(.nowait)
        guard let decoded = Json.fromJsonData(ProductsCount.self, from: response) else {
            return
        }
        self.total = decoded.count
        self.lastUpdate = Date()
    }
    
}
