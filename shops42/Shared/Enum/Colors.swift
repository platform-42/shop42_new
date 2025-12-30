//
//  Colors.swift
//  shops42
//
//  Created by Diederick de Buck on 29/01/2024.
//

import SwiftUI
import Foundation


enum RGB: Int {
    case coolBlue = 0x253146
    case categoryDesktop = 0x003366
    case categoryTablet = 0x0066CC
    case categoryMobile = 0x92C5F9
}


enum RGBLight: Int {
    case lime = 0x96F800
    case antracite = 0x22303C
    case white = 0xFFFFFF
    case teal = 0x009D94
    case vanilla = 0xF4F0E4
    case darkVanilla = 0xE7DBC2
    case beige = 0xC7BAAC
    case orange = 0xEDAB75
    case brightOrange = 0xF37454
    case shopify_green = 0x379088    // green signal color
}


enum RGBDark: Int {
    case lime = 0xA3FF66 // neon lime
    case antracite = 0x12181E // Charcoal
    case white = 0xE4E4E4 // Light Gray
    case teal = 0x00726B // deep teal
    case vanilla = 0x2C2B27
    case darkVanilla = 0x3A362D
    case beige = 0x8F8575 // taupe
    case orange = 0xC67A50 // burnt orange
    case brightOrange = 0xD15B3A // fiery coral
    case shopify_green = 0x5CAEAA
}


enum LabelColor: String {
    case button = "LC_button"
    case buttonAlert = "LC_buttonAlert"
    case picker = "LC_picker"
    case h2 = "LC_h2"
    case p = "LC_p"
}


enum BackgroundColor: String {
    case navbarLeft = "BG_navbarLeft"
    case navbarRight = "BG_navbarRight"
    case background = "BG_background"
    case header = "BG_header"
}


enum NavigationColor: String {
    case button = "NC_button"
    case buttonAlert = "NC_buttonAlert"
}



