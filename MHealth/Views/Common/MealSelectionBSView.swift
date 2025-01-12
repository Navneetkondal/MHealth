//// 	 
//	MealListView.swift
//	MHealth
//
//	Created By Navneet on 15/12/24
//


import SwiftUI

struct MealSelectionBSView: View {
    
    @Environment(\.dismiss) var dismiss
    var referenceTag: String
    var title: String = "Meal type"
    @State var items: [MealSelectionUIData]
    var isSingleSelection: Bool = true
    
    var actionPerfomed: ((MealSelectionUIData, String) -> Void)?
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 10){
                Text(title)
                    .font(MFontConstant.bold14.font)
                    .foregroundStyle(Color.mlabel)
                    .padding(.top, 12)
                
                List{
                    ForEach(items,id:  \.primaryKey ){ item in
                        HStack(alignment: .bottom, spacing: 10){
                            Image(img: item.isSelected ? .radioSelected : .radioUnselected)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color.mlabel)
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 10)
                            Text(item.title)
                                .foregroundColor(Color.mlabel)
                                .font(MFontConstant.bold14.font)
                        }
                        
                        .onTapGesture {
                            onSelection(item)
                        }
                    }
                    .listRowInsets(.init(top: 7, leading: 0, bottom: 0, trailing: 0))
                    .background(Color.clear)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .environment(\.defaultMinListRowHeight, 40)
                .listStyle(.plain)
                .background(.clear)
                .foregroundStyle(.clear)
                
                Divider()
                
                Button(action: {
                    print("Add Calories Action")
                    dismiss()
                    if let actionPerfomed = actionPerfomed{
                        actionPerfomed(.init(title: MHealthStringConstant.AddCalories.rawValue, primaryKey: 0),                     MHealthStringConstant.AddCalories.rawValue)
                    }
                }, label: {
                    HStack(alignment: .center, spacing: 8){
                        Image(systemImg: .sysImg_plus)
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10, height: 10)
                        Text(MHealthStringConstant.AddCalories.rawValue)
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.bold14.font)
                    }
                })
                .frame(width: 150, height: 40, alignment: .leading)
            }
            .padding(20)
        }
    }
    
    func onSelection(_ item: MealSelectionUIData){
        if isSingleSelection{
            for index in items.indices{
                items[index].isSelected = false
            }
            if let index = items.firstIndex(where: { $0.primaryKey == item.primaryKey && $0.title == item.title}){
                items[index].isSelected = !items[index].isSelected
                dismiss()
                if let actionPerfomed = actionPerfomed{
                    actionPerfomed(items[index], referenceTag)
                }
            }
        }
    }
}

