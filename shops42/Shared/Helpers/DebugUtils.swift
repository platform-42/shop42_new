//
//  DebugUtils.swift
//  shops42
//
//  Created by Diederick de Buck on 23/12/2025.
//


func debugLog(_ message: @autoclosure () -> String) {
    #if DEBUG
    print(message())
    #endif
}
