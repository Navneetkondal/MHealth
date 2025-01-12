//// 	 
//	WeightPickerView.swift
//	MHealth
//
//	Created By Navneet on 22/12/24
//


import SwiftUI

struct WeightPickerView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var inG: Int = 5
    @State var inKg: Int = 60
    @State var unit: WeightUnitsEnum = .kg
    private var units: [WeightUnitsEnum] = WeightUnitsEnum.allCases
    
    var actionPerfomed: ((Int,String, Int, String, PickerCompomentTypeEnum) -> Void)?
    
    init(inG: Int = 5, inKg: Int = 60, unit: WeightUnitsEnum = .kg, actionPerfomed: ( (Int,String, Int, String, PickerCompomentTypeEnum) -> Void)? = nil) {
        self.inG = inG
        self.inKg = inKg
        self.unit = unit
        self.actionPerfomed = actionPerfomed
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Set Weight")
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold15.font)
                    .padding(.leading, 15)
                
                Spacer()
                
                CurvedButtonView(title: "Save"){
                    if let actionPerfomed = actionPerfomed{
                        actionPerfomed(inKg, "." , inG, unit.rawValue, .Weight)
                    }
                    dismiss()
                }
            }
            
            HStack(alignment: .center, spacing: .zero){
                Picker(selection: $inKg, label: Text("")) {
                    let upperBound = unit == .kg ? 500 : 100
                    ForEach(0..<upperBound , id: \.self) { number in
                        Text("\(number)")
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.bold20.font)
                    }
                }
                .pickerStyle(.wheel)
                .frame(minWidth: 0)
                .clipped()
                
                Text( ".")
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold20.font)
                
                Picker(selection: $inG, label: Text("")) {
                    let upperBound: Int = 9
                    ForEach(0..<upperBound, id: \.self) { number in
                        Text("\(number)")
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.bold20.font)
                    }
                }
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
                .pickerStyle(.wheel)
                .frame(minWidth: 0)
                .clipped()
            }
        }
        .padding(10)
    }
}

enum WeightUnitsEnum: String, Codable, CaseIterable{
    case kg = "kg"
    case lb = "lb"
}
