////
//	FoodView.swift
//	MHealth
//
//	Created By Navneet on 18/12/24
//


import SwiftUI

struct FoodView: View {
    @EnvironmentObject var router: Router<MHealthNavigationRoute>
    @EnvironmentObject var viewModel: HealthViewModel
    
    @State private var searchText = ""
    @State private var isSearchActive = false
    @State var selectedDish: FoodDetail = .init(name: "", calories: 0)
    @State var foodTypeText:String
    @State var dishesList: [FoodDetail] = []
    @State var foodList: [FoodDetail] = []
    
    var body: some View {
        VStack(alignment:.center, spacing: .zero){
            SearbarUIKIT(searchbarText: $searchText, placeholderVal: .constant("Search for food"))
                .onChange(of: searchText){ _, newValue in
                    searchDishes(newValue)
                }
            if isSearchActive {
                List{
                    ForEach($dishesList, id: \.id){ $item in
                        FoodRowView(foodTypeText: foodTypeText, dish: $item, selectedDish: $selectedDish)
                            .padding(.zero)
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
                .scrollIndicators(.hidden)
                .ignoresSafeArea(.all)
            } else{
                Text("Frequently added")
                    .foregroundColor(Color.darkGray3)
                    .font(MFontConstant.semiBold14.font)
                List{
                    ForEach($foodList, id: \.id){ $item in
                        FoodRowView(foodTypeText: foodTypeText, dish: $item, selectedDish: $selectedDish)
                            .padding(.zero)
                    }
                    .listRowInsets(.init(top:0, leading: 0, bottom: 0, trailing: 0))
                    .background(.orange)
                    .listRowBackground(Color.red)
                    .listRowSeparator(.automatic)
                    .selectionDisabled()
                    .selectionDisabled(false)
                    .listRowSeparatorTint(Color.darkGray3)
                }
                .listStyle(InsetGroupedListStyle())
                .background(.lightViewBackground)
                .scrollIndicators(.hidden)
                .ignoresSafeArea(.all)
            }
            
            Spacer()
            if selectedDish.name != ""{
                VStack(alignment:.center, spacing: .zero){
                    Button(action:{
                        var meals =  viewModel.getFoodDishes(for: .init(rawValue: foodTypeText))
                        meals.append(selectedDish)
                        router.navigate(to: .AddCalories(foodTypeText,.LogMeal,meals ))
                    }){
                        Text("Next")
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.bold18.font)
                    }
                }
            }
            
        }
        
        .background(.viewbackground)
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
                        Text(foodTypeText)
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.bold20.font)
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.navigate(to: .AddFood(foodTypeText, viewModel.uiViewModel.getFoodNutrients()))
                } label: {
                    Image(systemImg: .sysImg_plus)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.mlabel)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .onAppear(){
            searchDishes(searchText)
            foodList = viewModel.getRecentFoodDishes(for: .init(rawValue: foodTypeText))
        }
    }
    
    func searchDishes(_ newValue: String){
        dishesList = viewModel.uiViewModel.getFoodDishesList().filter({  newValue.count >= 3 && $0.name.contains(searchText)})
        isSearchActive = !newValue.isEmpty && newValue.count >= 3
    }
}

extension FoodView{
    
    struct FoodRowView: View {
        @EnvironmentObject var router: Router<MHealthNavigationRoute>
        @EnvironmentObject var viewModel: HealthViewModel
        
        var foodTypeText: String
        @Binding var dish: FoodDetail
        @Binding var selectedDish: FoodDetail
        
        var body: some View {
            HStack(alignment: .center, spacing: 10){
                Button(action:{
                    selectedDish = selectedDish.name == dish.name ? .init(name: "", calories: 0) :  dish
                }){
                    Image(img: selectedDish.name == dish.name ? .radioSelected  :  .radioUnselected)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.mlabel)
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 10)
                }
                
                Rectangle()
                    .frame(width: 1.5)
                    .padding([.top, .bottom], 3)
                    .foregroundStyle(Color.mlabel)
                
                Button(action:{
                    print("To Be Implemented")
                }){
                    VStack(alignment: .leading){
                        Text(dish.name)
                            .foregroundColor(Color.mlabel)
                            .font(MFontConstant.semiBold14.font)
                        Text(dish.servingCalMsg)
                            .foregroundColor(Color.darkGray4)
                            .font(MFontConstant.regular12.font)
                    }
                }
                Spacer()
            }
            .frame(height: 50)
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            .background(.lightViewBackground)
        }
    }
}
