//
//  shops24App.swift
//  shops24
//
//  Created by Diederick de Buck on 12/01/2024.
//

import SwiftUI
import P42_colormanager

enum AppTheme {

    static let `default` = ColorTheme(
        light: .init(
            background: Color(hex: RGBLight.vanilla.rawValue),
            groupBoxBG: .white,
            navigationBG: Color(hex: RGBLight.shopify_green.rawValue),
            tabBarBG: Color(hex: RGBLight.darkVanilla.rawValue),
            pickerBG: .white,
            toolBarItems: .black,
            navigationText: .white,
            tint: Color(hex: RGBLight.shopify_green.rawValue),
            stroke: Color(hex: RGBLight.beige.rawValue),
            logo: Color(hex: RGBLight.shopify_green.rawValue)
        ),
        dark: .init(
            background: Color(hex: RGBDark.vanilla.rawValue),
            groupBoxBG: Color(hex: RGBDark.beige.rawValue).opacity(0.3),
            navigationBG: Color(hex: RGBDark.shopify_green.rawValue),
            tabBarBG: Color(hex: RGBDark.darkVanilla.rawValue),
            pickerBG: Color(hex: RGBDark.beige.rawValue).opacity(0.3),
            toolBarItems: .white,
            navigationText: .white,
            tint: Color(hex: RGBDark.shopify_green.rawValue),
            stroke: Color(hex: RGBDark.beige.rawValue),
            logo: Color(hex: RGBDark.shopify_green.rawValue)
        )
    )
}

@main
struct shops42App: App {
    
    @State private var colorManager = ColorManager(
        theme: AppTheme.default,
        colorScheme: .light
    )
    @StateObject private var udModel: UDModel = UDModel()

    var body: some Scene {
        WindowGroup {
            EntryView()
               .environment(colorManager)
               .environmentObject(udModel)
        }
    }
}


