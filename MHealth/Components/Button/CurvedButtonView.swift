////
//	CurvedButtonView.swift
//	MHealth
//
//	Created By Navneet on 25/12/24
//


import SwiftUI

struct CurvedButtonView: View {
    let width: CGFloat = 120
    let height: CGFloat = 35
    let alignment: Alignment = .center
    let title: String
    var clicked: (() -> Void)
    
    var body: some View {
        Button(action: {
            clicked()
        }, label: {
            Text(title)
                .foregroundColor(Color.mlabel)
                .font(MFontConstant.bold14.font)
        })
        .frame(width: width, height: height, alignment: alignment)
        .background(Color.btnBackground)
        .clipShape(.capsule)
    }
}


