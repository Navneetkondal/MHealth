////
//	AddFoodView.swift
//	MHealth  Aq ˀ//
//	Created By Navneet on 18/12/24
//


import SwiftUI
import Combine

struct AddFoodView: View {
    
    @EnvironmentObject var router: Router<MHealthNavigationRoute>
    @EnvironmentObject var viewModel: HealthViewModel
    @State var foodName: String = ""
    @State private var toast: Toast? = nil
    @State var foodNutrients: [FoodNutrients]
    var foodType: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero){
            MReusableCardView(.lightViewBackground, curve: 20 ) {
                VStack(alignment: .leading, spacing: .zero){
                    EnterFoodTxtField
                    List{
                        ForEach($foodNutrients, id: \.id){ $item in
                            NutrientsView(item: item)
                        }
                        .listRowInsets(.init(top:0, leading: 0, bottom: 0, trailing: 0))
                        .background(.clear)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .ignoresSafeArea(.all)
                    .scrollIndicators(.hidden)
                }

            }
            .padding( 10)
            FooterView
        }
        .background(.viewbackground)
        .navigationBarBackButtonHidden()
        .navigationTitle(Text("Add new food"))
        .showMToastView(toast: $toast)

    }
}

extension AddFoodView{
    
    var EnterFoodTxtField: some View{
        VStack(alignment: .leading){
            TextField("Enter Food Name", text: $foodName)
                .lineLimit(1)
                .multilineTextAlignment(.leading)
                .font(MFontConstant.regular14.font)
                .foregroundStyle(.mlabel)
                .frame(height: 50, alignment: .bottomLeading)
                .background(Color.clear)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.mlabel)
                .padding(.top, 5)
        }
        .background(.lightViewBackground)
        .padding([.leading, .trailing], 10)
        .padding([.bottom], 20)

    }
}

extension AddFoodView{
    struct NutrientsView: View {
        @State var item: FoodNutrients
        var body: some View {
            HStack{
                Text(item.type.string)
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.semiBold14.font)
                Spacer()
                VStack{
                    TextField("0", text: $item.value)
                        .lineLimit(1)
                        .multilineTextAlignment(.trailing)
                        .font(MFontConstant.semiBold14.font)
                        .foregroundStyle(.mlabel)
                        .keyboardType(.numberPad)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.mlabel)
                }
                .frame(width: 40)
                
                Text(item.unit.rawValue)
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.semiBold14.font)
                    .padding([.leading, .trailing], 10)
                
            }
            .frame(height: 65)
            .padding([.leading, .trailing], 10)
        }
    }
}

extension AddFoodView{
    var FooterView: some View{
        FooterButtonsView(){
            if foodName.count >= 3 && foodNutrients.allSatisfy({ $0.value != ""  && $0.value.isNumber}){
                viewModel.addFood(foodType,food: .init(name: foodName, nutrients: foodNutrients))
                router.navigateBack()
            }else{
                toast = Toast(style: .error, message: "Please fill all fields")
            }
        } cancelAction: {
            router.navigateBack()
        }
    }
}

