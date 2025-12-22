//
//  HistoryView.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 05/04/2023.
//

import SwiftUI
import P42_utils
import P42_viewmodifiers
import P42_watchos_widgets


enum HistoryLabel: String {
    case noOrders = "No orders"
}


struct HistoryView: View {
    
    func historyRestAPI(
        meta: Meta,
        portfolio: PortfolioModel,
        model: HistoryModel
    ) {
        if (meta.isCompleted) {
            meta.rearm()
            RestAPI.getRequestShopify(
                components: HistoryModel.historyLatestURL(
                    shop: portfolio.selectedShop,
                    endpoint: ShopifyURI.orders.rawValue,
                    limit: 10
                ),
                secret: portfolio.accessToken,
                meta: meta
            ) { data, meta in
                model.historyLatestHandler(response: data, meta: meta)
            }
        }
    }
    
    @EnvironmentObject var portfolio: PortfolioModel
    @State private var history: HistoryModel = HistoryModel()
    var meta: Meta = Meta(1)
    
    var body: some View {
        VStack {
            HeaderView(
                icon: Icon.history.rawValue,
                title: WatchView.history.rawValue,
                background: Color(BackgroundColor.header.rawValue)
            )
            List {
                ForEach(history.ordersList) { order in
                    HStack {
                        VStack {
                            let indicator = HistoryModel.indicatorFieldLogic(order.financial_status)
                            Text(order.name)
                            BadgedLabel(
                                labelColor: Widget.statusFieldColor(indicator),
                                backgroundColor: Widget.statusFieldBackgroundColor(indicator),
                                labelValue: order.financial_status,
                                padding: Padding.badge.rawValue
                            )
                            .font(.system(size: 8))
                        }
                        VStack {
                            Text(
                                Utils.autoscaleCurrency(
                                    order.current_total_price,
                                    currencyCode: order.currency
                                )
                            )
                            Text(Utils.formatDate(from: order.created_at))
                                .font(.system(size: 8))
                        }
                    }
                }
                if history.ordersList.count == 0 {
                    BadgedLabel(
                        labelColor: Widget.statusFieldColor(.warning),
                        backgroundColor: Widget.statusFieldBackgroundColor(.warning),
                        labelValue: HistoryLabel.noOrders.rawValue,
                        padding: Padding.badge.rawValue
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .scrollIndicators(.hidden)
            .listStyle(CarouselListStyle())
            FooterView(topic: portfolio.selectedShop)
        }
        .onAppear {
            self.historyRestAPI(meta: meta, portfolio: portfolio, model: history)
        }
        .onChange(of: portfolio.selectedShop) { oldValue, newValue in
            self.historyRestAPI(meta: meta, portfolio: portfolio, model: history)
        }
    }
}
