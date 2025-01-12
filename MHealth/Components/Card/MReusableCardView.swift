////
//	CardView.swift
//	MHealth
//
//	Created By Navneet on 17/11/24
//


import SwiftUI

struct MReusableCardView<Content: View>: View {
    let backgroundColor: Color
    let content: Content
    let curve: CGFloat
    
    init(_ backgroundColor: Color = .white, curve: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.backgroundColor = backgroundColor
        self.curve = curve
    }
    
    var body: some View {
        content
            .background(backgroundColor)
            .cornerRadius(curve)
            .background(
                RoundedRectangle(cornerRadius: curve)
                    .fill(.lightViewBackground)
                    .shadow(color: .lightViewBackground, radius: 3, x: 2, y: 3)
            )
    }
}
