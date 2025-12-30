//
//  ShopView.swift
//  shops24
//
//  Created by Diederick de Buck on 11/12/2022.
//

import Foundation
import SwiftUI
import P42_sound
import P42_viewmodifiers
import P42_colormanager


enum ShopLabel: String {
    case title = "Add Shop"
    case storename = "Enter storename ..."
}


struct ShopView: View {
    
    @Environment(ColorManager.self) var colorManager
    @Environment(AlertModel.self) var alertModel
    @Environment(PortfolioModel.self) var portfolio
    @Environment(\.dismiss) var dismiss
    
    @State private var shop: String = ""
    @State private var showAlert = false
    
    func validateShop(
        _ shop: String,
        numberOfShops: Int,
        maxNumberOfShops: Int
    ) -> (Topic, Diagnostics) {
        let minLength = 3
        let maxLength = 63
        
        guard shop.count >= minLength else {
            return (.shop, .tooShort)
        }
        
        guard shop.count <= maxLength else {
            return (.shop, .tooLong)
        }
        
        let allowedCharacters = "^[a-zA-Z0-9-]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", allowedCharacters)
        if !namePredicate.evaluate(with: shop) {
            return (.shop, .invalidShop)
        }
        
        if shop.hasPrefix("-") || shop.hasSuffix("-") {
            return (.shop, .invalidShop)
        }
        
        if shop.contains("--") {
            return (.shop, .invalidShop)
        }
        
        if numberOfShops > maxNumberOfShops {
            return (.shop, .tooMany)
        }
        return (.none, .okay)
    }
    
    var body: some View {
        ZStack {
            colorManager.background.ignoresSafeArea()
            VStack {
                Spacer()
                Text(ShopLabel.title.rawValue)
                Image(systemName: Icon.shop.rawValue)
                    .portrait(
                        width: Squares.portrait.rawValue,
                        height: Squares.portrait.rawValue
                    )
                Text("Specify storename\nwithout .myshopify.com")
                    .multilineTextAlignment(.center)
                TextField(ShopLabel.storename.rawValue, text: $shop)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                Spacer()
                Button {
                    let (topic, diagnostics) = validateShop(
                        shop,
                        numberOfShops: portfolio.numberOfShops,
                        maxNumberOfShops: 3
                    )
                    if (diagnostics == .okay) {
                        _ = portfolio.addShop(shop)
                        _ = portfolio.selectShop(shop)
                        Sound.playSound(
                            .click,
                            audible: UserDefaults.standard.bool(forKey: UDKey.sound.rawValue)
                        )
                        dismiss()
                    }
                    else {
                        showAlert = true
                        Sound.playSound(
                            .reject, 
                            soundExtension: .aif,
                            audible: UserDefaults.standard.bool(forKey: UDKey.sound.rawValue)
                        )
                        alertModel.showAlert(topic, diagnostics: diagnostics)
                    }
                } label: {
                    ButtonLabelWithImage(
                        buttonImageName: Icon.confirm.rawValue,
                        buttonTitle: ButtonTitle.confirm.rawValue.capitalized,
                        buttonColor: Color(LabelColor.button.rawValue),
                        buttonLabelColor: Color(LabelColor.button.rawValue),
                        buttonBackgroundColor: Color(NavigationColor.button.rawValue)
                    )
                }
                Spacer()
            }
        }
        .alert(alertModel.topicTitle, isPresented: $showAlert) {
            Button(ButtonTitle.ok.rawValue.capitalized) {
                if !([.invalidShop, .tooShort].contains(alertModel.diagnostics)) {
                    dismiss()
                }
            }
        } message: {
            Text(alertModel.errorMessage)
        }
    }
}
