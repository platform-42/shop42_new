//
//  View.swift
//  shops24
//
//  Created by Diederick de Buck on 09/03/2023.
//

import SwiftUI
import UIKit
import P42_viewmodifiers


extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(
            ButtonPress(
                onPress: {
                    onPress()
                },
                onRelease: {
                    onRelease()
                }
            )
        )
    }
}


