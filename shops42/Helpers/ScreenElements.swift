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




