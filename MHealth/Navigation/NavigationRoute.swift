////
//	NavigationRoute.swift
//	MHealth
//
//	Created By Navneet on 22/12/24
//


import SwiftUI

enum MHealthNavigationRoute: Routable {
    case SignIn
    case Signup
    case HomeTab
    case Food(String, [FoodDetail])
    case EditProfile(MHealthUser)
    case AddFood(String, [FoodNutrients])
    case AddCalories(String, MealRecord, [FoodDetail])
    
    var body: some View {
        switch self {
            case .Signup:
                SignupView()
            case .Food(let food, let foodDishes):
                FoodView(foodTypeText: food, foodList: foodDishes)
            case .HomeTab:
                HomeTabView()
            case .EditProfile(let user):
                EditProfileView(user: user)
            case .SignIn:
                LoginView()
            case .AddFood(let mealType, let foodNutrients):
                AddFoodView(foodNutrients: foodNutrients, foodType: mealType)
            case .AddCalories(let mealType,let mealRecord,let dishes):
                LogMealView(recordType: mealRecord, mealType: mealType, dishesData: dishes)
        }
    }
    
    static func == (lhs: MHealthNavigationRoute, rhs: MHealthNavigationRoute) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        
    }
}


