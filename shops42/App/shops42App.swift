//
//  shops24App.swift
//  shops24
//
//  Created by Diederick de Buck on 12/01/2024.
//

import SwiftUI
import UserNotifications
import UIKit
import StoreKit

@main
struct shops42App: App {
    
    init() {
        print("\(String(describing: type(of: self))).\(#function)")
        self.appearance()
    }
    
    func appearanceNavBar() -> Void {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 24),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.backgroundColor = UIColor(Color(BackgroundColor.navbarLeft.rawValue))     
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func appearancePageControl() -> Void {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color(OrnamentColor.pagination.rawValue))
    }
    
    func appearance() -> Void {
        self.appearanceNavBar()
        self.appearancePageControl()
    }
    
    var body: some Scene {
        WindowGroup {
            EntryView()
        }
    }
}


