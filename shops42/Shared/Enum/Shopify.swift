//
//  Shopify.swift
//  shops24
//
//  Created by Diederick de Buck on 07/12/2022.
//

import Foundation

enum ShopifyURIComponent: String {
    case schema = "https"
    case host = ".myshopify.com"
}

enum ShopifyURI: String {
    case orders = "/admin/api/2023-10/orders.json"
    case ordersCount = "/admin/api/2023-10/orders/count.json"
    case customersCount = "/admin/api/2023-10/customers/count.json"
    case productsCount = "/admin/api/2023-10/products/count.json"
    case abandoned = "/admin/api/2023-10/checkouts.json"
}

enum ShopifyTkn: String {
    case status
    case created_at
    case created_at_min
    case created_at_max
    case financial_status
    case fields
    case current_total_price
    case total_price
    case limit
    case currency
    case name
    case order
}

