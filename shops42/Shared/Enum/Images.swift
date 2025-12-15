//
//  Logo.swift
//  shops42
//
//  Created by Diederick de Buck on 14/01/2024.
//

import Foundation


enum Logo: String {
    case security = "person.badge.shield.checkmark.fill"
    case contact = "envelope.fill"
    case bugs = "ant.fill"
    case credits = "signature"
    case about = "info.circle.fill"
    case warning = "exclamationmark.triangle.fill"
}

enum Watermark: String {
    case graph = "Graph"
    case compass = "Comnpass"
    case horus = "Horus"
}

enum Icon: String {
    case logo = "Logo"
    case orders = "cart.fill"
    case history = "list.bullet"
    case revenue = "dollarsign.circle.fill"
    case customers = "person.crop.circle.fill"
    case products = "list.bullet.clipboard.fill"
    case abandoned = "cart.fill.badge.questionmark"
    case soundOn = "speaker.wave.3.fill"
    case soundOff = "speaker.fill"
    case trash = "trash.fill"
    case plus = "plus"
    case minus = "minus"
    case share = "square.and.arrow.up.fill"
    case sync = "arrow.triangle.2.circlepath.circle.fill"
    case mail = "paperplane.fill"
    case login = "person.fill"
    case confirm = "checkmark.circle.fill"
    case shop = "cart"
    case connection = "power.circle.fill"
    case about = "house.fill"
    case licenseOn = "checkmark.seal.fill"
    case licenseOff = "xmark.seal.fill"
    case highlight = "guidepoint.vertical.arrowtriangle.forward"
}

enum TabIcon: String {
    case shops = "basket.fill"
    case logout = "rectangle.portrait.and.arrow.right.fill"
    case settings = "gearshape.2.fill"
    case help = "questionmark.circle.fill"
}

enum IconSecurity: String {
    case granted = "lock.fill"
    case prohibited = "lock.open"
}
