////
//	HeightPickerView.swift
//	MHealth
//
//	Created By Navneet on 22/12/24
//

import Foundation
import SwiftUI

enum PickerCompomentTypeEnum{
    case Weight
    case Height
}

struct HeightPickerView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var inCm: Int = 8
    @State var inMm: Int = 8
    @State var unit: HeightUnitsEnum = .cm
    private var units: [HeightUnitsEnum] = HeightUnitsEnum.allCases
    
    init(inCm: Int = 8, inMm: Int = 8, unit: HeightUnitsEnum = .cm, actionPerfomed: ((Int,String, Int, String, PickerCompomentTypeEnum)  -> Void)? = nil) {
        self.inCm = inCm
        self.inMm = inMm
        self.unit = unit
        self.actionPerfomed = actionPerfomed
    }
    
    var actionPerfomed: ((Int, String, Int, String, PickerCompomentTypeEnum) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Set Height")
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold15.font)
                    .padding(.leading, 15)
                Spacer()
                
                CurvedButtonView(title: "Save"){
                    if let actionPerfomed = actionPerfomed{
                        actionPerfomed(inCm, unit == .cm ? "." : ",", inMm, unit.rawValue, .Height)
                    }
                    dismiss()
                }
            }
            
            HStack(alignment: .center, spacing: .zero){
                Picker(selection: $inCm, label: Text("")) {
                    let range = unit == .cm ? 0..<305 : 0..<10
                    ForEach(range, id: \.self) { number in
                        Text("\(number)")
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.bold20.font)
                    }
                }
                .labelsHidden()
                .pickerStyle(.wheel)
                .frame(minWidth: 0)
                .clipped()
                Text(unit == .cm ? "." : ",")
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold20.font)
                
                Picker(selection: $inMm, label: Text("")) {
                    let range = unit == .cm ? 0..<10 : 0..<11
                    ForEach(range, id: \.self) { number in
                        Text("\(number)")
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.bold20.font)
                    }
                }
                .labelsHidden()
                .pickerStyle(.wheel)
                .frame(minWidth: 0)
                .clipped()
                
                Picker(selection: $unit, label: Text("")) {
                    ForEach(units, id: \.self) { unit in
                        Text("\(unit)")
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.bold20.font)
                    }
                }
                .labelsHidden()
                .pickerStyle(.wheel)
                .frame(minWidth: 0)
                .clipped()
            }
        }
        .padding(10)
    }
}

enum HeightUnitsEnum: String, Codable, CaseIterable{
    case cm = "cm"
    case ft = "ft,in"
}
