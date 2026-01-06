//
//  BadgedView.swift
//  shops42
//
//  Created by Diederick de Buck on 06/01/2026.
//

import SwiftUI
import P42_utils
import P42_watchos_widgets


@ViewBuilder
public func DelayBadge(
    now: Date,
    lastUpdate: Date?,
    boundaryMinutes: Int = 1,
    backgroundColor: Color
) -> some View {
    if let text = Utils.delayIndicator(
        now: now,
        lastUpdate: lastUpdate!,
        boundaryMinutes: boundaryMinutes
    ) {
        BadgedLabel(
            labelColor: .black,
            backgroundColor: backgroundColor,
            labelValue: text,
            padding: EdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5)
        )
    }
}
