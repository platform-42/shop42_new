//
//  ScreenElements.swift
//  shops24
//
//  Created by Diederick de Buck on 27/11/2022.
//

import Foundation
import SwiftUI
import P42_extensions
import P42_viewmodifiers


struct BackgroundView: View {
    var watermarkImageName: String
    var opacity: CGFloat
    var body: some View {
        VStack {
            Image(watermarkImageName)
                .resizable()
                .scaledToFit()
                .opacity(opacity)
                .edgesIgnoringSafeArea(.all)
                .padding(50)
            Spacer()
        }
    }
}

struct SettingsLabel: View {
    var label: String
    var icon: Icon
    var iconColor: IconColor
    var body: some View {
        
        Label {
            Text(label)
        } icon: {
            Image(systemName: icon.rawValue)
                .foregroundColor(Color(iconColor.rawValue))
        }
    }
}

/*
struct ContentHeader: View {
    var titleLabel: HelpLabel
    var logo: Logo
    var logoColor: Color
    var portraitSize: CGFloat
    
    var body: some View {
        Spacer()
        Text(titleLabel.rawValue.capitalized)
            .modifier(H2(labelColor: Color(LabelColor.h2.rawValue)))
        Image(systemName: logo.rawValue)
            .portrait(width: portraitSize, height: portraitSize)
            .foregroundColor(logoColor)
    }
}
*/

struct ShopListItem: View {
    var shopLabel: String
    var shopLabelColor: Color
    
    var body: some View {
        Text(shopLabel)
            .font(.title2)
            .foregroundColor(shopLabelColor)
            .padding()
    }
}

struct ButtonLabelWithImage: View {
    var buttonImageName: String
    var buttonTitle: String
    var buttonColor: Color
    var buttonLabelColor: Color
    var buttonBackgroundColor: Color
    var body: some View {
        HStack {
            Image(systemName: buttonImageName)
                .foregroundColor(buttonColor)
            Text(buttonTitle)
                .foregroundColor(buttonLabelColor)
        }
        .padding()
        .background(buttonBackgroundColor)
        .clipShape(Capsule())
    }
}




