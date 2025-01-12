////
//  Toast.swift
//  ToastDemo
//
//  Created by Navneet on 11/01/25.
//


import Foundation

struct Toast: Equatable {
    
    var style: ToastStyle
    var message: String
    var duration: Double = 2
    var width: Double = .infinity
    var onDismiss: (() -> Void)? = nil
    
    static func == (lhs: Toast, rhs: Toast) -> Bool {
        lhs.style == rhs.style && lhs.message == rhs.message &&
        lhs.duration == rhs.duration &&
        lhs.width == rhs.width
    }
}
