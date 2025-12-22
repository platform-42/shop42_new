//
//  OrderView.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 05/04/2023.
//

import SwiftUI
import P42_utils
import P42_extensions
import P42_watchos_widgets


enum OrdersLabel: String {
    case unpaid = "Unpaid"
}


struct OrdersView: View {
    
    func ordersRestAPI(
        meta: Meta,
        portfolio: PortfolioModel,
        model: OrdersModel
    ) {
        if (meta.isCompleted) {
            meta.rearm()
            RestAPI.getRequestShopify(
                components: OrdersModel.ordersTodayURL(
                    shop: portfolio.selectedShop,
                    endpoint: ShopifyURI.ordersCount.rawValue
                ),
                secret: portfolio.accessToken,
                meta: meta,
                handler: orders.ordersTodayHandler
            )
            RestAPI.getRequestShopify(
                components: OrdersModel.ordersTodayPendingURL(
                    shop: portfolio.selectedShop,
                    endpoint: ShopifyURI.ordersCount.rawValue
                ),
                secret: portfolio.accessToken,
                meta: meta
            ) { data, meta in
                model.ordersTodayPendingHandler(response: data, meta: meta)
            }
        }
    }
    
    @EnvironmentObject var portfolio: PortfolioModel
    @State private var orders: OrdersModel = OrdersModel()
    var meta: Meta = Meta(2)
    
    var body: some View {
        VStack {
            HeaderView(
                icon: Icon.orders.rawValue,
                title: WatchView.orders.rawValue,
                background: Color(BackgroundColor.header.rawValue)
            )
            NumberAndStatView(
                period: Period.today.rawValue,
                connectionColor: .red,
                primaryValue: String(orders.today),
                primaryColor: .primary,
                secondaryLabel: "\(OrdersLabel.unpaid.rawValue): ",
                secondaryValue: String(orders.todayPending),
                widgetStatus: OrdersModel.indicatorFieldlogic(orders.todayPending)
            )
            FooterView(topic: portfolio.selectedShop)
        }
        .onAppear {
            self.ordersRestAPI(meta: meta, portfolio: portfolio, model: orders)
        }
        .onChange(of: portfolio.selectedShop) { oldValue, newValue in
            self.ordersRestAPI(meta: meta, portfolio: portfolio, model: orders)
        }
    }
}
