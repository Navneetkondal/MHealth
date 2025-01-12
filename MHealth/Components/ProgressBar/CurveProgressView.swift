////
//	CurveProgressView.swift
//	MHealth
//
//	Created By Navneet on 07/12/24
//	

import SwiftUI

struct CurveProgressView: View {
    let config: MProgressBarConfig.config
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 220.0 / 360)
                .stroke(style: StrokeStyle(lineWidth:config.lineWidth, lineCap: .round, lineJoin: .round))
                .opacity(0.3)
                .foregroundColor(config.foregroundColor)
                .rotationEffect(.degrees(-90 - 110))
            
            Circle()
                .trim(from: 0, to: (config.value * 220.0) / 360)
                .stroke(style: StrokeStyle(lineWidth: config.lineWidth, lineCap: .round, lineJoin: .round))
                .fill(config.foregroundColor)
                .rotationEffect(.degrees(-90 - 110))
            
            VStack {
                Text(config.getProgressString()).font(Font.system(size: 14)).bold().foregroundColor(Color.mlabel)
            }
        }
    }
}

struct ProgressThumb: View {
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 30, height: 30)
    }
}

