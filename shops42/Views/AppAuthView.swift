//
//  AppAuthView.swift
//  shops24
//
//  Created by Diederick de Buck on 07/12/2022.
//

import Foundation
import UIKit
import SwiftUI


enum AppAuthNIB: String {
    case storyboard = "Main"
    case storyboardId = "AppAuthViewController"
}

struct AppAuthView: UIViewControllerRepresentable {
    
    init() {
    }
    
    func makeUIViewController(context content: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: AppAuthNIB.storyboard.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: AppAuthNIB.storyboardId.rawValue)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
}
