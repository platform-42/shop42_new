//
//  RevenueView.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 16/04/2023.
//

import SwiftUI
import P42_utils
import P42_extensions
import P42_watchos_widgets


enum RevenueLabel: String {
    case unpaid = "Unpaid"
}


struct RevenueView: View {
    
    func revenueRestAPI(
        meta: Meta,
        portfolio: PortfolioModel,
        model: RevenueModel
    ) {
        if (meta.isCompleted) {
            meta.rearm()
            RestAPI.getRequestShopify(
                components: RevenueModel.revenueTodayURL(
                    shop: portfolio.selectedShop,
                    endpoint: ShopifyURI.orders.rawValue
                ),
                secret: portfolio.accessToken,
                meta: meta
            ) { data, meta in
                model.revenueTodayHandler(response: data, meta: meta)
            }
        }
    }
    
    @EnvironmentObject var portfolio: PortfolioModel
    @State private var revenue: RevenueModel = RevenueModel()
    var meta: Meta = Meta(1)
    
    var body: some View {
        VStack {
            HeaderView(
                icon: Icon.revenue.rawValue,
                title: WatchView.revenue.rawValue,
                background: Color(BackgroundColor.header.rawValue)
            )
            NumberAndStatView(
                period: Period.today.rawValue,
                connectionColor: .red,
                primaryValue: Utils.autoscale(
                    revenue.todayAmount,
                    currencyCode: revenue.currency
                ),
                primaryColor: .primary,
                secondaryLabel: "\(RevenueLabel.unpaid.rawValue): ",
                secondaryValue: Utils.autoscale(
                    revenue.todayAmountPending,
                    currencyCode: revenue.currency
                ),
                widgetStatus: RevenueModel.indicatorFieldLogic(revenue.todayAmountPending)
            )
            FooterView(topic: portfolio.selectedShop)
        }
        .onAppear {
            self.revenueRestAPI(meta: meta, portfolio: portfolio, model: revenue)
        }
        .onChange(of: portfolio.selectedShop) { oldValue, newValue in
            self.revenueRestAPI(meta: meta, portfolio: portfolio, model: revenue)
        }
    }
}
