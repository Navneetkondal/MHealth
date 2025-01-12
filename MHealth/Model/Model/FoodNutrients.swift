//// 	 
//	FoodNutrients.swift
//	MHealth
//
//	Created By Navneet on 11/01/25
//


import Foundation
import SwiftUI

class FoodNutrients: Codable, Equatable{
    static func == (lhs: FoodNutrients, rhs: FoodNutrients) -> Bool {
        lhs.id == rhs.id &&  lhs.unit == rhs.unit && lhs.type == rhs.type && lhs.isRequired == rhs.isRequired && lhs.value == rhs.value
    }
    
    var id: UUID
    var unit: NutrientsUnits
    var type: NutrientsType
    var isRequired: Bool
    @Published var value: String = ""
    
    enum CodingKeys: CodingKey {
        case id, unit, type, isRequired, value
    }
    
    init(id: UUID = UUID(), unit: NutrientsUnits, type: NutrientsType, isRequired: Bool, value: String = "") {
        self.id = id
        self.unit = unit
        self.type = type
        self.isRequired = isRequired
        self.value = value
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.unit = try container.decodeIfPresent(NutrientsUnits.self, forKey: .unit) ?? .kcal
        self.type = try container.decodeIfPresent(NutrientsType.self, forKey: .type) ?? .caloriesPer
        self.isRequired = try container.decodeIfPresent(Bool.self, forKey: .isRequired) ?? true
        self.value = try container.decodeIfPresent(String.self, forKey: .value) ?? ""
        
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.unit, forKey: .unit)
        try container.encodeIfPresent(self.type, forKey: .type)
        try container.encodeIfPresent(self.isRequired, forKey: .isRequired)
        try container.encodeIfPresent(self.value, forKey: .value)
    }
    
    enum NutrientsUnits: String, Codable{
        case kcal = "kcal"
        case gram = "g"
        case mg = "mg"
        case percentage = "%"
    }
    
    var updatedVal: Double{
        Double(value) ?? 0
    }
    
    enum NutrientsType: String, Codable, CaseIterable{
        case caloriesPer
        case carbohydrates
        case fat
        case protien
        case saturatedFat
        case transFat
        case cholesterol
        case sodium
        case potassium
        case fibre
        case sugars
        case vitaminA900
        case vitaminC90
        case calcium1300
        case iron18
        
        var string: String{
            switch self{
                case .caloriesPer:
                    "Calories per  serving"
                case .carbohydrates:
                    "Total carbohydrates"
                case .fat:
                    "Total fat"
                case .protien:
                    "Protien"
                case .saturatedFat:
                    "Saturated Fat"
                case .transFat:
                    "Trans Fat"
                case .cholesterol:
                    "Cholesterol"
                case .sodium:
                    "Sodium"
                case .potassium:
                    "Potassium"
                case .fibre:
                    "Fibre"
                case .sugars:
                    "Sugars"
                case .vitaminA900:
                    "Vitamin A (100% = 900mcg RAE)*"
                case .vitaminC90:
                    "Vitamin C (100% = 1,300mg)*"
                case .calcium1300:
                    "Calcium (100% = 90mg)*"
                case .iron18:
                    "Calcium (100% = 18mg)*"
            }
        }
    }
}


