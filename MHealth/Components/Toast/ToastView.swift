////
//  ToastView.swift
//  ToastDemo
//
//  Created by Navneet on 11/01/25.
//


import SwiftUI

struct ToastView: View {
    
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconFileName)
                .renderingMode(.template)
                .foregroundColor(Color.mlabel)
            Text(message)
                .font(Font.caption)
                .foregroundColor(Color.mlabel)
            
            Spacer(minLength: 10)
            
            Button {
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .renderingMode(.template)
                    .foregroundColor(Color.mlabel)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(style.themeColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style.themeColor, lineWidth: 1)
                .opacity(0.6)
        )
        .padding(.horizontal, 16)
    }
}
