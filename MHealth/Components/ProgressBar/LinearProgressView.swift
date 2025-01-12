////
//	LinearProgressView.swift
//	MHealth
//
//	Created By Navneet on 08/12/24
//
//


import SwiftUI

struct LinearProgressView: View {
    var progress: CGFloat
    var msg: String? = ""
    var bgColor = Color.black.opacity(0.2)
    var filledColor = Color.blue
    var width: CGFloat = 70
    
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width =  geometry.size.width
            VStack(alignment: .center){
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(bgColor)
                        .frame(width: width,
                               height: height)
                        .cornerRadius(height / 2.0)
                    
                    Rectangle()
                        .foregroundColor(filledColor)
                        .frame(width: (self.progress < 100) ? width * (self.progress / 100) :  self.width,
                               height: height)
                        .cornerRadius(height / 2.0)
                }
            }
        }
    }
}
