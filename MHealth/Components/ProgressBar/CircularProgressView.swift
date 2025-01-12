////
//	CircularProgress View.swift
//	MHealth
//
//	Created By Navneet on 24/11/24
//
//

import SwiftUI


struct CircularProgressView: View {
    
    let progressConfig: MProgressBarConfig.config
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                CircularShape()
                    .stroke(style: StrokeStyle(lineWidth: progressConfig.lineWidth))
                    .fill(progressConfig.bgColor)
                Text(progressConfig.progressTest())
                    .font(MFontConstant.regular11.font)
                    .bold()
                    .scaledToFit()
                CircularShape(percent: progressConfig.value)
                    .stroke(style: StrokeStyle(lineWidth: progressConfig.lineWidth))
                    .fill(progressConfig.foregroundColor)
            }
            .animation(.easeIn(duration: 1.0), value: progressConfig.value)
            .padding(progressConfig.lineWidth/1.5)
        }
    }
}

#Preview {
    CircularProgressView(progressConfig: .init(lineWidth: 10, bgColor: .red, foregroundColor: .green, value: 50, total: 0))
}

struct CircularShape: Shape {
    
    var percent : Double
    var startAngle : Double
    
    typealias AnimatableData = Double
    var animatableData: Double {
        get {
            return percent
        }
        set {
            percent = newValue
        }
    }
    
    init(percent: Double = 100, startAngle: Double = -90) {
        self.percent = percent
        self.startAngle = startAngle
    }
    
    func path(in rect: CGRect) -> Path {
        
        let width = rect.width
        let height = rect.height
        let radius = min(width,height) / 2
        let center = CGPoint(x: width / 2, y: height / 2)
        let endAngle = (self.percent / 100 * 360) + startAngle
        
        
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngle), endAngle: Angle(degrees: endAngle), clockwise: false)
        }
    }
}

struct MProgressBarConfig{
    struct config{
        var lineWidth: CGFloat = 4
        var bgColor : Color = Color.blue.opacity(0.2)
        var foregroundColor: Color = Color.blue
        var textColor: Color = .mlabel
        var value: Double
        var total: Double? = nil
        var msg: String = "%d / %d"
        var customCenterMsg = ""
        var progressType: ProgressType = .percentage
        
        func progressTest() -> String{
            switch progressType{
                case .percentage:
                    return String(format:  "%.1f", value) + "%"
                case .value:
                    return "\(value.rounded())"
                case .custom:
                    return customCenterMsg
            }
        }
        
        func getProgressString() -> String{
            if let total = total{
                return String(format: msg, value, total)
            }else{
                return String(format: msg, value)
            }
        }
    }
    
    enum ProgressType{
        case percentage
        case custom
        case value
    }
}

