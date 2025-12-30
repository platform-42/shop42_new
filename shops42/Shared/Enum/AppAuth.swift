//
//  AppAuth.swift
//  shops24
//
//  Created by Diederick de Buck on 16/04/2023.
//

import Foundation


enum AppAuthEndpoint: String {
    case authorize = "/admin/oauth/authorize"
    case access = "/admin/oauth/access_token"
}

enum AppAuthSecrets: String {
    case consumerKey = "bd1d936c3eabe4c7a49189d2585ab45b"
    case consumerSecret = "aa14d8e845d2f05378789f30bd411db3"
    case response = "code"
    case redirectURI = "https://platform-42.com/oauth/"
}


enum AppAuthScope: String, CaseIterable {
    case read_products
    case read_orders
    case read_customers
    case read_shipping
}


enum AppAuthToken: String, CaseIterable {
    case shop
}
