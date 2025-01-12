//// 	 
//	DatePickerView.swift
//	MHealth
//
//	Created By Navneet on 31/12/24
//	


import Foundation
import SwiftUI

struct DatePickerView: View {
    
    @Environment(\.dismiss) var dismiss
    var title: String = "Select Date"
    @State var date: Date = .now
    var pickerType: DatePickerConstant = .datePicker
    
    var actionPerfomed: ((Date, DatePickerConstant) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(title)
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold15.font)
                    .padding(.leading, 15)
                Spacer()
                
                CurvedButtonView(title: "Save"){
                    if let actionPerfomed = actionPerfomed{
                        actionPerfomed(date, pickerType)
                    }
                    dismiss()
                }
            }
            
            HStack(alignment: .center, spacing: .zero){
                DatePicker("",selection: $date,displayedComponents: pickerType == .datePicker ? .date : [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(alignment: .center)
                    .padding(.horizontal, 8.0)
            }
        }
        .padding(10)
    }
}

extension DatePickerView{
    enum DatePickerConstant{
        case datePicker
        case timePicker
    }
}
