//// 	 
//	FoodDetail.swift
//	MHealth
//
//	Created By Navneet on 18/12/24
//	


import Foundation
class FoodActivity: Codable{
    var id: UUID?
    var mealType: MealTypeEnum? = nil
    var mealTimeStamp: TimeInterval? = nil
    var meals: [FoodDetail]
    
    init(id: UUID = UUID(), mealType: MealTypeEnum?, mealTimeStamp: TimeInterval?, meals: [FoodDetail]) {
        self.id = id
        self.mealType = mealType
        self.mealTimeStamp = mealTimeStamp
        self.meals = meals
    }
    
    enum CodingKeys: CodingKey {
        case id
        case mealType
        case mealTimeStamp
        case meals
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id)
        self.mealType = try container.decodeIfPresent(MealTypeEnum.self, forKey: .mealType)
        self.mealTimeStamp = try container.decodeIfPresent(TimeInterval.self, forKey: .mealTimeStamp)
        self.meals = try container.decodeIfPresent([FoodDetail].self, forKey: .meals) ?? []
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.mealType, forKey: .mealType)
        try container.encodeIfPresent(self.mealTimeStamp, forKey: .mealTimeStamp)
        try container.encodeIfPresent(self.meals, forKey: .meals)
    }
}

class FoodDetail: Codable{
    var id: UUID?
    var name: String
    var nutrients: [FoodNutrients]
    var isCaloriesOnly: Bool
    var isSelected: Bool
    var serving: Double = 1
    
    @Published var servingCalMsg: String = ""
    
    convenience init(id: UUID = UUID(), name: String, calories: Int) {
        let nutrient: FoodNutrients = .init(unit: .kcal, type: .caloriesPer, isRequired: true, value:  String(calories))
        self.init(id: id, name: name, nutrients: [nutrient], isCaloriesOnly: true, isSelected: false)
    }
    
    init(id: UUID = UUID(), name: String, nutrients: [FoodNutrients],isCaloriesOnly: Bool = false, isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.nutrients = nutrients
        self.isCaloriesOnly = isCaloriesOnly
        self.isSelected = isSelected
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case nutrients
        case isSelected, isCaloriesOnly, serving
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.nutrients = try container.decodeIfPresent([FoodNutrients].self, forKey: .nutrients) ?? []
        self.isCaloriesOnly = try container.decodeIfPresent(Bool.self, forKey: .isCaloriesOnly) ?? false
        self.isSelected = try container.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
        self.serving = try container.decodeIfPresent(Double.self, forKey: .serving) ??  1
        
        servingCalMsg = getCalorieServingMsg()
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.nutrients, forKey: .nutrients)
        try container.encodeIfPresent(self.isCaloriesOnly, forKey: .isCaloriesOnly)
        try container.encodeIfPresent(self.serving, forKey: .serving)
    }
    
    func getCalorieServingMsg() -> String{
        if let first = nutrients.first(where: { $0.type == .caloriesPer}){
            return first.value + " "  + first.unit.rawValue + ", \(serving) serving"
        }
        return "\(serving) serving"
    }
}
