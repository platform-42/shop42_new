//
//  AbandonedView.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 16/04/2023.
//

import SwiftUI
import P42_utils
import P42_extensions
import P42_watchos_widgets


enum AbandonedLabel: String {
    case missed = "Missed"
}


struct AbandonedView: View {
    
    func abandonedRestAPI(
        meta: Meta,
        portfolio: PortfolioModel,
        model: AbandonedModel
    ) {
        if (meta.isCompleted) {
            meta.rearm()
            RestAPI.getRequestShopify(
                components: AbandonedModel.abandonedTodayURL(
                    shop: portfolio.selectedShop,
                    endpoint: ShopifyURI.abandoned.rawValue
                ),
                secret: portfolio.accessToken,
                meta: meta
            ) { data, meta in
                model.abandonedTodayHandler(response: data, meta: meta)
            }
        }
    }
    
    @EnvironmentObject var portfolio: PortfolioModel
    @State private var abandoned: AbandonedModel = AbandonedModel()
    var meta: Meta = Meta(1)
    
    var body: some View {
        VStack {
            HeaderView(
                icon: Icon.abandoned.rawValue,
                title: WatchView.abandoned.rawValue,
                background: Color(BackgroundColor.header.rawValue)
            )
            NumberAndStatView(
                period: Period.today.rawValue,
                primaryValue: String(abandoned.today),
                primaryColor: .primary,
                secondaryLabel: "\(AbandonedLabel.missed.rawValue): ",
                secondaryValue: Utils.autoscale(
                    abandoned.todayTotal,
                    currencyCode: abandoned.currency
                ),
                widgetStatus: AbandonedModel.indicatorFieldlogic(abandoned.today)
            )
            FooterView(topic: portfolio.selectedShop)
            Spacer()
        }
        .onAppear {
            self.abandonedRestAPI(meta: meta, portfolio: portfolio, model: abandoned)
        }
        .onChange(of: portfolio.selectedShop) { oldValue, newValue in
            self.abandonedRestAPI(meta: meta, portfolio: portfolio, model: abandoned)
        }
    }
}
