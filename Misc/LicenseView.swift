//
//  PaywallView.swift
//  shops42
//
//  Created by Diederick de Buck on 22/08/2024.
//

import SwiftUI
import StoreKit
import P42_extensions
import P42_viewmodifiers

enum LicenseLabel: String {
    case models = "Licensing models"
}

struct LicenseView: View {
    
    @EnvironmentObject var transactionObserver: TransactionObserver
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            BackgroundView(
                watermarkImageName: Watermark.graph.rawValue,
                opacity: 0.05
            )
            VStack {
                SubscriptionStoreView(
                    productIDs: [
                        ProductId.monthly.rawValue,
                        ProductId.yearly.rawValue
                    ]) {
                        VStack {
                            Text(LicenseLabel.models.rawValue)
                                .modifier(H2(labelColor: Color(LabelColor.h2.rawValue)))
                            Image(systemName: transactionObserver.hasSubscription ? Icon.licenseOn.rawValue : Icon.licenseOff.rawValue)
                                .portrait(
                                    width: Squares.portrait.rawValue,
                                    height: Squares.portrait.rawValue
                                )
                                .foregroundColor(Color(OrnamentColor.logo.rawValue))
                        }
                    }
                    .subscriptionStoreButtonLabel(.multiline)
                    .storeButton(.visible, for: .restorePurchases)
                    .subscriptionStoreControlStyle(.prominentPicker)
                    .onInAppPurchaseCompletion { product, result in
                        switch (result) {
                        case .success(.success(_)):
                            print("*** ACCEPTED - ENABLED ***")
                            UserDefaults.standard.set(true, forKey: UserDefaultsKey.hasLicense.rawValue)
                            UserDefaults.standard.set(Date().nextMonth.toString(.date), forKey: UserDefaultsKey.renewalDate.rawValue)
                            dismiss()
                        default:
                            print("*** WAIT - IN PROGRESS ***")
                        }
                    }
                    .onChange(of: transactionObserver.hasSubscription) {
                        if transactionObserver.hasSubscription {
                            dismiss()
                        }
                    }
            }
            //                .navigationTitle(TabItem.license.rawValue.capitalized)
            //                .navigationBarTitleDisplayMode(.large)
        }
    }
}

