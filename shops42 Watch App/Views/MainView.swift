//
//  ContentView.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 27/12/2022.
//

import SwiftUI
import P42_viewmodifiers


private enum MainLabel: String {
    case licenseSync = "License Sync"
    case regularSync = "Please Sync"
}

struct MainView: View {
    
    let watch = WatchReceive()
    @StateObject var portfolioModel: PortfolioModel = PortfolioModel.instance

    var body: some View {
        TabView {
            ForEach(portfolioModel.selectedViews.sorted(), id: \.self) { viewEnum in
                view(for: viewEnum)
                    .environmentObject(portfolioModel)
            }
        }
        .modifier(
            EmptyModifier(
                numberOfItems: portfolioModel.numberOfViews,
                placeholder: VStack {
                    Image("AppIconReview")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(15.0)
                    Label(
                        portfolioModel.licenseCheck ? MainLabel.licenseSync.rawValue : MainLabel.regularSync.rawValue,
                        systemImage: Icon.sync.rawValue
                    )
                    .labelStyle(BackgroundLabelStyle(
                        color: .white,
                        backgroundColor: Color(NavigationColor.button.rawValue),
                        radius: 15.0
                        )
                    )
                }
            )
        )
    }
    
    @ViewBuilder
    func view(for destination: WatchView) -> some View {
        switch destination {
            case .orders: OrdersView()
            case .history: HistoryView()
            case .products: ProductsView()
            case .abandoned: AbandonedView()
            case .revenue: RevenueView()
            case .customers: CustomersView()
        }
    }
}
