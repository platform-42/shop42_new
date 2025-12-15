//
//  Shopify.swift
//  shops42
//
//  Created by Gino Sponton on 26/07/2024.
//

import Foundation


/*
 *  Keep in mind that enumerators that are used for internal
 *  proccessing must be treated differently than those who are used
 *  for decorative purposes
 *
 *  WatchView enumeratopr is used for Dynamic View-lookup,
 *  so it cannot have overriding raw-values
 *
 *  if you want to invoke OrdersView on an enumerator basis,
 *  it's raw value cannot be "Last 5 orders"
 */

enum WatchView: String, Comparable {
    static func < (lhs: WatchView, rhs: WatchView) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    case orders
    case history
    case revenue
    case customers
    case products
    case abandoned
}


