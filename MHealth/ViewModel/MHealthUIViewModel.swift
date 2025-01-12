//// 	 
//	MHealthUIViewModel.swift
//	MHealth
//
//	Created By Navneet on 15/12/24
//	


import Foundation
import Combine
import SwiftUI

class MHealthUIViewModel: ObservableObject{
    @Published var dashboardUICards: [DashboardCardData] = []
    @Published var mealTypes: [MealSelectionUIData] = []
    
    init(){
        self.dashboardUICards = MHealthUtils.returnModelObjFromLocalJson("HomeUI", [DashboardCardData].self) ?? []
        self.mealTypes = MealTypeEnum.allCases.enumerated().map({ .init(title: $0.element.rawValue, primaryKey: $0.offset)})
    }
    
    func getFoodNutrients() -> [FoodNutrients]{
        var nutrients: [FoodNutrients] = []
        FoodNutrients.NutrientsType.allCases.forEach{ type in
            if type == .caloriesPer{
                nutrients.append(.init(unit: .kcal, type: type, isRequired: false))
            }else if type == .sodium || type == .cholesterol || type == .potassium {
                nutrients.append(.init(unit: .mg, type: type, isRequired: false))
            }else if type == .vitaminA900 || type == .vitaminC90 || type == .calcium1300 || type == .iron18{
                nutrients.append(.init(unit: .percentage, type: type, isRequired: false))
            }else{
                nutrients.append(.init(unit: .gram, type: type, isRequired: false))
            }
        }
        return nutrients
    }
    
    func getFoodDishesList() -> [FoodDetail]{
        MHealthUtils.returnModelObjFromLocalJson("FoodNutrients", [FoodDetail].self) ?? []
    }
    
    func getCurrentMeal()  -> String{
        calculateMealTypes()
        let currentHour = Int(Date().getDateStringFromCurrentRegion(.HH)) ?? 6
        switch currentHour {
            case 6..<10:
                return MealTypeEnum.breakFast.rawValue
            case 10..<14:
                return MealTypeEnum.lunch.rawValue
            case 15..<17:
                return MealTypeEnum.afternoonSnack.rawValue
            case 14..<18:
                return MealTypeEnum.eveningSnack.rawValue
            case 18..<22:
                return MealTypeEnum.dinner.rawValue
            default:
                return MealTypeEnum.breakFast.rawValue
        }
    }
    
    func calculateMealTypes(){
        self.mealTypes = MealTypeEnum.allCases.enumerated().map({ .init(title: $0.element.rawValue, primaryKey: $0.offset)})
    }
}
