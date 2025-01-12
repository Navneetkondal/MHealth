////
//	AddCaloriesView.swift
//	MHealth
//
//	Created By Navneet on 11/01/25
//


import SwiftUI

enum MealRecord: String{
    case LogMeal = "Log meal"
    case addCalories = "Add Calories"
}

struct LogMealView: View {
    @EnvironmentObject var router: Router<MHealthNavigationRoute>
    @EnvironmentObject var viewModel: HealthViewModel
    var recordType: MealRecord
    @State var mealType: String
    @State var mealTime: Date = .now
    @State var calories: Int = 550
    @State var activeSheet: ActiveBSType? = nil
    @State var dishesData: [FoodDetail] = []
    @State var totalCaloriesForMeal: String  = ""
    @State var totalCarbFartProtien: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 30){
            MealSelectionView
                .padding(.top, 30)
            
            TimePickerView
            
            if recordType == .addCalories{
                CaloriesPickerView
            } else if recordType == .LogMeal{
                VStack(alignment: .leading, spacing: .zero){
                    MReusableCardView(.lightViewBackground, curve: 20) {
                        CardRowView(title: $totalCaloriesForMeal, subTitle: $totalCarbFartProtien, iconString: nil){
                            router.navigate(to: .AddCalories(mealType, .addCalories, []))
                        }
                    }
                    .padding([.leading, .trailing], 25)
                    
                    Text("Foods")
                        .foregroundColor(.gray)
                        .font(MFontConstant.regular13.font)
                        .padding([.leading, .trailing], 25)
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                    
                    
                    VStack(alignment: .leading, spacing: .zero){
                        List{
                            ForEach($dishesData, id: \.id){ $item in
                                CardRowView(title: $item.name, subTitle: $item.servingCalMsg, iconString: nil){
                                }
                            }
                            .listRowInsets(.init(top:0, leading: 0, bottom: 0, trailing: 0))
                            .background(.lightViewBackground)
                            .listRowBackground(Color.lightViewBackground)
                            .listRowSeparator(.automatic)
                            .selectionDisabled()
                            .listRowSeparatorTint(Color.darkGray3)
                            CardRowView(title: .constant("Add food"), subTitle: .constant(""), iconString: .sysImg_plus){
                                router.navigate(to: .Food(mealType, viewModel.getFoodDishes(for: .init(rawValue: mealType))))
                            }
                            .listRowInsets(.init(top:0, leading: 0, bottom: 0, trailing: 0))
                            .background(.lightViewBackground)
                            .listRowBackground(Color.lightViewBackground)
                            .listRowSeparator(.automatic)
                            .selectionDisabled()
                            .listRowSeparatorTint(Color.darkGray3)
                            CardRowView(title: .constant("Add Calories"), subTitle: .constant(""), iconString: .sysImg_plus){
                                router.navigate(to: .AddCalories(mealType, .addCalories, []))
                            }
                            .listRowInsets(.init(top:0, leading: 0, bottom: 0, trailing: 0))
                            .background(.lightViewBackground)
                            .listRowBackground(Color.lightViewBackground)
                            .listRowSeparator(.automatic)
                            .selectionDisabled()
                            .listRowSeparatorTint(Color.darkGray3)
                        }
                        .listStyle(InsetGroupedListStyle())
                        .background(.lightViewBackground)
                        .ignoresSafeArea(.all)
                        .scrollIndicators(.hidden)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                }
            }
            FooterView
        }
        .frame(maxWidth: .infinity)
        
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.navigateBack()
                } label: {
                    HStack{
                        Image(systemImg: .sysImg_chevronLeft)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.mlabel)
                            .frame(width: 10, height: 20)
                        Text(recordType.rawValue)
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.bold20.font)
                    }
                }
            }
        }
        .sheet(item: $activeSheet) { item in
            switch item {
                case .timePicker:
                    //Date Picker BS
                    DatePickerView(title: "Set time", pickerType: .timePicker, actionPerfomed: datePickerActionPerformed)
                        .presentationDetents([.height(300)])
                        .presentationCornerRadius(15)
                        .presentationDragIndicator(.hidden)
            }
        }
        .onAppear(){
            if recordType == .LogMeal{
                let total = viewModel.setTotalCalCarbFat(for: .init(rawValue: mealType))
                totalCaloriesForMeal = total.totalCaloriesForMeal
                totalCarbFartProtien = total.totalCarbFartProtien
            }
        }
    }
}

extension LogMealView{
    
    var MealSelectionView: some View{
        Menu {
            ForEach(viewModel.uiViewModel.mealTypes, id: \.primaryKey) { type in
                Button() {
                    mealType = type.title
                } label: {
                    Text(type.title)
                        .foregroundColor(.mlabel)
                        .background(Color.clear)
                        .font(MFontConstant.semiBold14.font)
                }
            }
        } label: {
            HStack(alignment:.center, spacing: 5){
                Text(mealType)
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold14.font)
                Image(systemImg: .sysImg_arrowtriangle)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.mlabel)
                    .frame(width: 5, height: 5)
            }
        }
    }
}

extension LogMealView{
    
    var TimePickerView: some View{
        Button{
            activeSheet = .timePicker
        } label: {
            MReusableCardView(.darkGray3, curve: 25) {
                Text(mealTime.getDateStringFromUTC(.Hmma))
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold14.font)
                    .frame(width: 150, height: 50)
            }
        }
    }
}

extension LogMealView{
    var CaloriesPickerView: some View{
        MReusableCardView(.lightViewBackground, curve: 20) {
            VStack(alignment: .leading){
                Text("Calories")
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.semiBold14.font)
                
                Picker(selection: $calories, label: Text("")) {
                    ForEach(0..<7000, id: \.self) { number in
                        Text("\(number)")
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.bold20.font)
                    }
                }
                .labelsHidden()
                .pickerStyle(.wheel)
                .frame(minWidth: 0)
                .clipped()
            }
            .padding(15)
        }
        .padding(10)
    }
}

extension LogMealView{
    var FooterView: some View{
        FooterButtonsView(){
            viewModel.updateFoodCalories(mealType, timeStamp: mealTime.timeIntervalSince1970, calories: calories)
            router.navigateBack()
        } cancelAction: {
            router.navigateBack()
        }
    }
    
    struct CardRowView: View {
        
        @Binding var title: String
        @Binding var subTitle: String
        var iconString: MImageStringEnum?
        var action: () -> Void
        
        var body: some View {
            MReusableCardView(.lightViewBackground, curve: 0) {
                HStack(alignment: .center, spacing: .zero){
                    VStack(alignment: .leading, spacing: .zero){
                        Text(title)
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.semiBold14.font)
                        Text(subTitle)
                            .foregroundColor(Color.darkGray4)
                            .font(MFontConstant.regular12.font)
                        
                    }
                    Spacer()
                    if let iconString = iconString{
                        Button(action:{
                            action()
                        }){
                            Image(systemImg: iconString )
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color.mlabel)
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 10)
                        }
                    }
                }
                .frame(height: 65)
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing], 12)
                .background(.lightViewBackground)
            }
        }
    }
}

extension LogMealView{
    func datePickerActionPerformed(date: Date, type: DatePickerView.DatePickerConstant){
        mealTime = date
    }
}

extension LogMealView{
    
    enum ActiveBSType: Identifiable {
        case timePicker
        
        var id: Int {
            hashValue
        }
    }
}

extension LogMealView{
    
    struct FoodRowView: View {
        
        var foodTypeText: String
        @Binding var dish: FoodDetail
        
        var body: some View {
            VStack(alignment: .leading){
                Text(dish.name)
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.semiBold14.font)
                Text("310 kcal, 1 serving")
                    .foregroundColor(Color.darkGray4)
                    .font(MFontConstant.regular12.font)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
        }
    }
}
