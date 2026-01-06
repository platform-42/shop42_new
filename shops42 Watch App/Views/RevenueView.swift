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
    @State private var revenueModel: RevenueModel = RevenueModel()
    var meta: Meta = Meta(1)
    
    var body: some View {
        VStack {
            HeaderView(
                connectionColor: revenueModel.widgetConnectionColor(),
                title: WatchView.revenue.rawValue,
                background: Color(BackgroundColor.header.rawValue)
            )
            NumberAndStatView(
                period: Period.today.rawValue,
                connectionColor: .red,
                primaryValue: Utils.autoscale(
                    revenueModel.todayAmount,
                    currencyCode: revenueModel.currency
                ),
                primaryColor: .primary,
                secondaryLabel: "\(RevenueLabel.unpaid.rawValue): ",
                secondaryValue: Utils.autoscale(
                    revenueModel.todayAmountPending,
                    currencyCode: revenueModel.currency
                ),
                widgetStatus: RevenueModel.indicatorFieldLogic(revenueModel.todayAmountPending)
            )
            TimelineView(.periodic(from: .now, by: 120)) { context in
                DelayBadge(
                    now: context.date,
                    lastUpdate: revenueModel.lastUpdate,
                    backgroundColor: Widget.stateFieldColor(.neutral)
                )
            }
        }
        .onAppear {
            self.revenueRestAPI(meta: meta, portfolio: portfolio, model: revenueModel)
        }
        .onChange(of: portfolio.selectedShop) { oldValue, newValue in
            self.revenueRestAPI(meta: meta, portfolio: portfolio, model: revenueModel)
        }
    }
}
