//
//  ProductView.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 16/04/2023.
//

import SwiftUI
import P42_utils
import P42_extensions
import P42_watchos_widgets


struct ProductsView: View {
    
    func productsRestAPI(
        meta: Meta,
        portfolio: PortfolioModel,
        model: ProductsModel
    ) {
        if (meta.isCompleted) {
            meta.rearm()
            RestAPI.getRequestShopify(
                components: ProductsModel.productsTodayURL(
                    shop: portfolio.selectedShop,
                    endpoint: ShopifyURI.productsCount.rawValue
                ),
                secret: portfolio.accessToken,
                meta: meta,
                handler: products.productsTodayHandler
            )
            RestAPI.getRequestShopify(
                components: ProductsModel.productsTotalURL(
                    shop: portfolio.selectedShop,
                    endpoint: ShopifyURI.productsCount.rawValue
                ),
                secret: portfolio.accessToken,
                meta: meta
            ) { data, meta in
                model.productsTotalHandler(response: data, meta: meta)
            }
        }
    }
    
    @EnvironmentObject var portfolio: PortfolioModel
    @State private var products: ProductsModel = ProductsModel()
    var meta: Meta = Meta(2)
    
    var body: some View {
        VStack {
            HeaderView(
                icon: Icon.products.rawValue,
                title: WatchView.products.rawValue,
                background: Color(BackgroundColor.header.rawValue)
            )
            NumberAndStateView(
                period: Period.today.rawValue,
                connectionColor: .red,
                primaryValue: String(products.total),
                primaryColor: .primary,
                secondaryValue: String(products.today),
                secondaryColor: .secondary,
                widgetState: ProductsModel.indicatorArrowLogic(products: products.today)
            )
            FooterView(topic: portfolio.selectedShop)
            Spacer()
        }
        .onAppear {
            self.productsRestAPI(meta: meta, portfolio: portfolio, model: products)
        }
        .onChange(of: portfolio.selectedShop) { oldValue, newValue in
            self.productsRestAPI(meta: meta, portfolio: portfolio, model: products)
        }
    }
}
