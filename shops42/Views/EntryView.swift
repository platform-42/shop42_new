//
//  LaunchView.swift
//  shops24
//
//  Created by Diederick de Buck on 28/05/2023.
//

import SwiftUI

enum LaunchLabel: String {
    case title = "Shopify Sales"
}


struct LaunchView: View {
    @Binding var isActive: Bool
    @State var size: Double
    @State var opacity: Double
    
    var body: some View {
        ZStack {
            Color(BackgroundColor.background.rawValue)
                .ignoresSafeArea()
            VStack {
                Image(Icon.logo.rawValue)
                    .portrait(width: 200, height: 200)
                Text(LaunchLabel.title.rawValue)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 0.9
                    self.opacity = 1.00
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct EntryView: View {
    @State private var isActive: Bool = false
    
    @ViewBuilder
    func view(initial isActive: Bool) -> some View {
        switch isActive {
        case true:
            MainView()
        default:
            LaunchView(
                isActive: $isActive,
                size: 0.8,
                opacity: 0.5
            )
        }
    }
    
    var body: some View {
        view(initial: isActive)
    }
}
