//
//  CustomerView.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 05/04/2023.
//

import SwiftUI
import P42_utils
import P42_extensions
import P42_watchos_widgets
import P42_watchos_colormanager

struct CustomersView: View {
    
    func customersRestAPI(
        meta: Meta,
        portfolio: PortfolioModel,
        model: CustomersModel
    ) {
        if (meta.isCompleted) {
            meta.rearm()
            RestAPI.getRequestShopify(
                components: CustomersModel.customersTodayURL(
                    shop: portfolio.selectedShop,
                    endpoint: ShopifyURI.customersCount.rawValue
                ),
                secret: portfolio.accessToken,
                meta: meta,
                handler: customersModel.customersTodayHandler
            )
            RestAPI.getRequestShopify(
                components: CustomersModel.customersTotalURL(
                    shop: portfolio.selectedShop,
                    endpoint: ShopifyURI.customersCount.rawValue
                ),
                secret: portfolio.accessToken,
                meta: meta
            ) { data, meta in
                model.customersTotalHandler(response: data, meta: meta)
            }
        }
    }
    
    @EnvironmentObject var portfolio: PortfolioModel
    @State private var customersModel: CustomersModel = CustomersModel()
    var meta: Meta = Meta(2)
    
    var body: some View {
        VStack {
            HeaderView(
                icon: Icon.customers.rawValue,
                connectionColor: widget
                title: WatchView.customers.rawValue,
                background: Color(BackgroundColor.header.rawValue)
            )
            NumberAndStateView(
                period: Period.today.rawValue,
                connectionColor: .red,
                primaryValue: String(customersModel.total),
                primaryColor: .primary,
                secondaryValue: String(customersModel.today),
                secondaryColor: .secondary,
                widgetState: CustomersModel.indicatorArrowLogic(customers: customersModel.today)
            )
            TimelineView(.periodic(from: .now, by: 120)) { context in
                FooterView(
                    topic: portfolio.selectedShop,
                    lastUpdate: Utils.delayIndicator(
                        now: context.date,
                        lastUpdate: customersModel.lastUpdate,
                        boundaryMinutes: 1
                    )
                )
            }
        }
        .onAppear {
            self.customersRestAPI(meta: meta, portfolio: portfolio, model: customersModel)
        }
        .onChange(of: portfolio.selectedShop) { oldValue, newValue in
            self.customersRestAPI(meta: meta, portfolio: portfolio, model: customersModel)
        }
    }
}
