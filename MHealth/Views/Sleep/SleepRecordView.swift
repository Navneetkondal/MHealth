////
//    SleepRecordView.swift
//    MHealth
//
//    Created By Navneet on 15/12/24
//


import SwiftUI

struct SleepRecordView: View {
    
    @EnvironmentObject var viewModel: HealthViewModel
    @ObservedObject var card: DashboardCardData
    
    @Environment(\.dismiss) var dismiss
    @State var startAngle: Double = 0
    // since our to progress is0.5
    // 0.5 * 360 = 180
    @State var toAngle: Double =  216
    
    @State var startProgress: CGFloat = 0
    @State var toProgress: CGFloat = 0.6
    
    var body: some View {
        NavigationStack{
            VStack{
                SleepTimeSlider()
                    .padding(.top, 20)
                
                Button(action: {
                    viewModel.updateSleepValue(for: card.type, start:Date().getTimeFromAngle(angle: startAngle), end: Date().getTimeFromAngle(angle:toAngle), isManual: true)
                    dismiss()
                }, label: {
                    Text("Save")
                        .font(MFontConstant.bold14.font)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .padding(.horizontal)
                        .frame(width: 150, height: 45)
                        .background(.blue, in: Capsule())
                })
                .padding(.top, 20)
                
                HStack(spacing: 10){
                    VStack(alignment: .leading, spacing: 8){
                        Label{
                            Text("Bedtime")
                                .foregroundColor(.black)
                        } icon: {
                            Image(systemName: "moon.fill")
                                .foregroundColor(.blue)
                        }
                        .font(.callout)
                        
                        Text(Date().getTimeFromAngle(angle: startAngle).formatted(date: .omitted, time: .shortened))
                            .font(MFontConstant.bold17.font)
                            .foregroundColor(Color.mlabel)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 8){
                        Label{
                            Text("Wakeup")
                                .foregroundColor(.black)
                        } icon: {
                            Image(systemName: "alarm")
                                .foregroundColor(.blue)
                        }
                        .font(.callout)
                        
                        Text(Date().getTimeFromAngle(angle: toAngle).formatted(date: .omitted, time: .shortened))
                            .font(MFontConstant.bold17.font)
                            .foregroundColor(Color.mlabel)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                .background(.black.opacity(0.06), in: RoundedRectangle(cornerRadius: 15))
                .padding(.top, 10)
            }
            .padding()
        }
    }
}

//MARK: - Sleep Time Slider
extension SleepRecordView{
    
    @ViewBuilder
    func SleepTimeSlider()->some View{
        GeometryReader{ proxy in
            let width = proxy.size.width
            ZStack{
                ZStack{
                    ForEach( 1...60 , id:  \.self){index in
                        Rectangle()
                            .fill(index % 5 == 0 ? .black : .darkGray0)
                            .frame(width: 2, height: index % 5 == 0 ? 12 : 5)
                            .offset(y: (width - 60) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 6))
                    }
                    
                    // Mark: Clock Text
                    let texts = [6,5,4,3,2,1,12,11,10,9,8,7]
                    ForEach(texts.indices, id: \.self){ index in
                        Text("\(texts[index])")
                            .font(.caption.bold())
                            .foregroundColor(.black)
                            .rotationEffect(.init(degrees: Double(index) * -330))
                            .offset(y: (width - 100) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 330))
                    }
                }
                
                Circle()
                    .stroke(.black.opacity(0.06), lineWidth: 30)
                
                let reverseRotation = (startProgress > toProgress ) ? -Double((1 - startProgress) * 360) : 0
                
                Circle()
                    .trim(from: startProgress > toProgress ? 0 : startProgress, to: toProgress + (-reverseRotation / 360) )
                    .stroke(.blue, style: .init(lineWidth: 40, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reverseRotation))
                
                
                // Slider
                Image(systemName: "moon.fill")
                    .font(.callout)
                    .foregroundColor(Color.blue)
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -startAngle))
                    .background(.white, in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: startAngle))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                onDrag(value: gesture, fromSlider: true)
                            })
                    .rotationEffect(.init(degrees: -90))
                
                // Slider
                Image(systemName: "alarm")
                    .font(.callout)
                    .foregroundColor(Color.blue)
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -toAngle))
                    .background(.white, in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: toAngle))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                onDrag(value: gesture)
                            })
                    .rotationEffect(.init(degrees: -90))
                
                VStack(spacing: 6){
                    
                    Text("\(Date().getTimeDiffFromAngle(start: startAngle, end: toAngle).hours)hr")
                        .foregroundColor(.gray)
                        .font(.largeTitle.bold())
                    
                    Text("\(Date().getTimeDiffFromAngle(start: startAngle, end: toAngle).min)min")
                        .foregroundColor(.gray)
                }
                .scaleEffect(1.1)
            }
        }
        .frame(width: UIScreen.main.bounds.width / 1.6 , height:    UIScreen.main.bounds.width / 1.6 )
    }
}

//MARK: - Drag Action
extension SleepRecordView{
    
    func onDrag(value: DragGesture.Value, fromSlider: Bool = false){
        // MARK: Converting Translation into angle
        let vector = CGVector(dx:  value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        var angle =   radians  * 180 / .pi
        angle = angle < 0 ? (360 + angle) : angle
        // if  angle < 0{angle =  360 + angle}
        let progress = angle / 360
        if fromSlider{
            self.startAngle = angle
            self.startProgress = progress
        }else{
            self.toAngle = angle
            self.toProgress = progress
        }
    }
}
