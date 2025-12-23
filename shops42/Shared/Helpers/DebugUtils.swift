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


func debugLog(
    _ message: @autoclosure () -> String,
    file: String = #fileID,
    function: String = #function,
    line: Int = #line
) {
    #if DEBUG
    let filename = file.components(separatedBy: "/").last ?? file
    print("[\(filename):\(line)] \(function) -> \(message())")
    #endif
}
