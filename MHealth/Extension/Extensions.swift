//// 	 
//	Extensions.swift
//	Notes
//
//	Created By Navneet on 17/11/24
//


import Foundation
import SwiftUICore
import UIKit

extension Sequence {
    public func toDictionary<Key: Hashable>(with selectKey: (Iterator.Element) -> Key) -> [Key:Iterator.Element]?{
        var dict: [Key:Iterator.Element] = [:]
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}

extension String{
    func removeSpaces() -> String{
        self.trimmingCharacters(in: .whitespaces)
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero).insets
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}

extension EnvironmentValues {
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
