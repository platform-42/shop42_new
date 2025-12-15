//
//  Alert.swift
//  shops24
//
//  Created by Diederick de Buck on 02/06/2023.
//

import Foundation

enum Topic: String {
    case mail
    case shop
    case license
    case sync
    case security
    case none = ""
}

enum Diagnostics: String {
    case okay = "Okay"
    case unsubscribed = "Please subscribe by selecting a shop"
    case invalidAccessToken = "Invalid access-token, revoke shop first"
    case unauthorized = "Please authenticate first"
    case invalidShop = "Shopname is invalid\nShopname can only contain letters, digits, and hyphens."
    case tooShort = "Shopname is too short"
    case tooLong = "Shopname is too long"
    case tooMany = "You cannot configure more than 3 shops"
    case unlicensed = "Please obtain a monthly or yearly subscription"
    case noMailAccount = "The Mail app on your iOS device is not set up with a default email account. Please configure an email account"
}

@Observable class AlertModel {
    
    var topicTitle: String
    var errorMessage: String
    var diagnostics: Diagnostics
    
    init() {
        self.topicTitle = Topic.none.rawValue
        self.diagnostics = Diagnostics.okay
        self.errorMessage = Diagnostics.okay.rawValue
    }
    
    func showAlert(_ topic: Topic, diagnostics: Diagnostics) {
        self.topicTitle = topic.rawValue.capitalized
        self.diagnostics = diagnostics
        self.errorMessage = self.diagnostics.rawValue
    }
}
