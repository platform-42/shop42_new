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
                handler: customers.customersTodayHandler
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
    @State private var customers: CustomersModel = CustomersModel()
    var meta: Meta = Meta(2)
    
    var body: some View {
        VStack {
            HeaderView(
                icon: Icon.customers.rawValue,
                title: WatchView.customers.rawValue,
                background: Color(BackgroundColor.header.rawValue)
            )
            NumberAndStateView(
                period: Period.today.rawValue,
                connectionColor: .red,
                primaryValue: String(customers.total),
                primaryColor: .primary,
                secondaryValue: String(customers.today),
                secondaryColor: .secondary,
                widgetState: CustomersModel.indicatorArrowLogic(customers: customers.today)
            )
            FooterView(topic: portfolio.selectedShop)
            Spacer()
        }
        .onAppear {
            self.customersRestAPI(meta: meta, portfolio: portfolio, model: customers)
        }
        .onChange(of: portfolio.selectedShop) { oldValue, newValue in
            self.customersRestAPI(meta: meta, portfolio: portfolio, model: customers)
        }
    }
}
