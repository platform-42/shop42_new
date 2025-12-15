//
//  ColorManager.swift
//  GA42
//
//  Created by Diederick de Buck on 28/10/2024.
//

import Foundation
import SwiftUI
import P42_utils


@Observable
class ColorManager {

    var colorScheme: ColorScheme
    var darkMode: Bool
    var contentDarkMode: ColorScheme
    var contentLightMode: ColorScheme
    
    init(
        _ colorScheme: ColorScheme = .light,
        contentDarkMode: ColorScheme = .light,
        contentLightMode: ColorScheme = .light
    ) {
        self.colorScheme = colorScheme
        self.darkMode = (colorScheme == .dark)
        self.contentDarkMode = contentDarkMode
        self.contentLightMode = contentLightMode
    }
    
    func updateColorScheme(
        _ newColorScheme: ColorScheme
    ) {
        self.colorScheme = newColorScheme
        self.darkMode = (colorScheme == .dark)
    }
    
    var navbarContent: ColorScheme {
        self.darkMode ?
            self.contentDarkMode :
            self.contentLightMode
    }
    
    var background: Color {
        self.darkMode ? 
            Color(hex: RGBDark.vanilla.rawValue) :
            Color(hex: RGBLight.vanilla.rawValue)
    }
    
    var groupBoxBG: Color {
        self.darkMode ? 
            Color(hex: RGBDark.beige.rawValue).opacity(0.3) :
            Color(hex: RGBLight.beige.rawValue).opacity(0.3)
    }
    
    var navbarBG: Color {
        self.darkMode ? 
            Color(hex: RGBDark.beige.rawValue) :
            Color(hex: RGBLight.beige.rawValue)
    }
    
    var toolbarItems: Color {
        self.darkMode ? 
            .black :
            .black
    }
    
    var tabBarItems: Color {
        self.darkMode ? 
            Color(hex: RGBDark.brightOrange.rawValue) :
            Color(hex: RGBLight.brightOrange.rawValue)
    }
    
    var tabBarBG: Color {
        self.darkMode ?
            Color(hex: RGBDark.darkVanilla.rawValue) :
            Color(hex: RGBLight.darkVanilla.rawValue)
    }
    
    var navigationBG: Color {
        self.darkMode ? 
            Color(hex: RGBDark.brightOrange.rawValue) :
            Color(hex: RGBLight.brightOrange.rawValue)
    }
    
    var navigationText: Color {
        self.darkMode ?
            .white :
            .white
    }

    var logo: Color {
        self.darkMode ? 
            Color(hex: RGBDark.brightOrange.rawValue) :
            Color(hex: RGBLight.brightOrange.rawValue)
    }
    
    var tint: Color {
        self.darkMode ?
            Color(hex: RGBDark.brightOrange.rawValue) :
            Color(hex: RGBLight.brightOrange.rawValue)
    }
    
    var pickerBG: Color {
        self.darkMode ?
            Color(hex: RGBDark.beige.rawValue).opacity(0.3) :
            Color(hex: RGBLight.beige.rawValue).opacity(0.3)
    }
    
    var stroke: Color {
        self.darkMode ?
            Color(hex: RGBDark.beige.rawValue) :
            Color(hex: RGBLight.beige.rawValue)
    }
        
}
