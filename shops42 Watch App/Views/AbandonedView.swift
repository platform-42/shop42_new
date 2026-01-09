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


private enum AbandonedLabel: String {
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
    
    @EnvironmentObject var portfolioModel: PortfolioModel
    @State private var abandonedModel: AbandonedModel = AbandonedModel()
    var meta: Meta = Meta(1)
    
    var body: some View {
        VStack {
            HeaderView(
                connectionColor: abandonedModel.widgetConnectionColor(),
                title: WatchView.abandoned.rawValue,
                background: Color(BackgroundColor.header.rawValue)
            )
            NumberAndStatView(
                period: Period.today.rawValue,
                connectionColor: .red,
                primaryValue: String(abandonedModel.today),
                primaryColor: .primary,
                secondaryLabel: "\(AbandonedLabel.missed.rawValue): ",
                secondaryValue: Utils.autoscale(
                    abandonedModel.todayTotal,
                    currencyCode: abandonedModel.currency
                ),
                widgetStatus: AbandonedModel.indicatorFieldlogic(abandonedModel.today)
            )
            TimelineView(.periodic(from: .now, by: 120)) { context in
                FooterView(topic: portfolioModel.selectedShop) {
                    DelayBadge(
                        now: context.date,
                        lastUpdate: abandonedModel.lastUpdate,
                        backgroundColor: Widget.stateFieldColor(.neutral)
                    )
                }
            }
        }
        .onAppear {
            self.abandonedRestAPI(meta: meta, portfolio: portfolioModel, model: abandonedModel)
        }
        .onChange(of: portfolioModel.selectedShop) { oldValue, newValue in
            self.abandonedRestAPI(meta: meta, portfolio: portfolioModel, model: abandonedModel)
        }
    }
}
