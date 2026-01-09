//
//  ProportionalPage.swift
//  shops42
//
//  Created by Diederick de Buck on 09/01/2026.
//

import SwiftUI

struct ProportionalPage<Header: View, Content: View, Footer: View>: View {
    let header: Header
    let content: Content
    let footer: Footer

    var body: some View {
        VStack(spacing: 0) {
            header

            content
                .frame(maxHeight: .infinity)
                .layoutPriority(1)

            footer
                .frame(maxHeight: .infinity)
                .layoutPriority(1)
        }
    }
}
