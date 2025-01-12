//// 	 
//	HealthDetail.swift
//	MHealth
//
//	Created By Navneet on 08/12/24
//	


import Foundation
import SwiftUI

class HealthDetail: Identifiable, Codable, Equatable{
    var date: TimeInterval?
    var data: String?
    var message: String?
    var target: HealthTarget = .init()
    // Sleep
    var startTimeStamp: TimeInterval = 0
    var endTimeStamp: TimeInterval = 0
    //Meal
    var meals: [FoodActivity] = []
    
    @Published var value: Double = 0
    @Published var valueDesc: String  = ""
    @Published var percentage: Double = 0
    
    var isManual = false
    
    init(date: TimeInterval? = nil  , data: String? = "", message: String = "", target: HealthTarget, value: Double) {
        self.date = date
        self.data = data
        self.message = message
        self.target = target
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {
        case date, data, message, target, value, isManual, meals
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.date = try container?.decodeIfPresent(TimeInterval.self, forKey: .date)
        self.data = try container?.decodeIfPresent(String.self, forKey: .data)
        self.message = try container?.decodeIfPresent(String.self, forKey: .message)
        self.target = try container?.decodeIfPresent(HealthTarget.self, forKey: .target) ?? .init()
        self.value = try container?.decodeIfPresent(Double.self, forKey: .value) ?? 0
        self.isManual = try container?.decodeIfPresent(Bool.self, forKey: .isManual) ?? false
        self.meals = try container?.decodeIfPresent([FoodActivity].self, forKey: .meals) ?? []
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.date, forKey: .date)
        try container.encodeIfPresent(self.data, forKey: .data)
        try container.encodeIfPresent(self.message, forKey: .message)
        try container.encodeIfPresent(self.target, forKey: .target)
        try container.encodeIfPresent(self.value, forKey: .value)
        try container.encodeIfPresent(self.isManual, forKey: .isManual)
        try container.encodeIfPresent(self.meals, forKey: .meals)
    }
    
    static func == (lhs: HealthDetail, rhs: HealthDetail) -> Bool {
        return lhs.date == rhs.date &&
        lhs.data == rhs.data &&
        lhs.message == rhs.message &&
        lhs.target == rhs.target &&
        lhs.value == rhs.value
    }
    
    func getTotalCalories() -> Double{
        var calories = 0.0
        meals.forEach({ meal in
            meal.meals.forEach({ item in
                if let cal = item.nutrients.first(where: { $0.type == .caloriesPer })?.updatedVal {
                    calories += cal
                }
            })
        })
        return calories
    }
    
    var todayDate: Date?{
        guard let date = date else{
            return nil
        }
        return .init(timeIntervalSince1970:  date)
    }
    
    func updateTimeStamp(){
        date = Date().getTimeStampFromDateUTC()
    }
    
    func getActivityValue(_ str: String) -> String{
        guard let unit = target.unit else{
            return str
        }
        return str + " " + unit.rawValue
    }
    
    func getActivityValue(_ newVal: Double? = nil, newTarget: Double? = nil) -> String{
        let unit = self.target.unit ?? .none
        let target =  newTarget ?? self.target.target
        let val = Int((newVal ?? value))
        switch unit{
            case .steps:
                guard let targetVal = target else{
                    return ("\(val)" + unit.rawValue)
                }
                return ("\(val) / \(Int(targetVal))") +  unit.rawValue
            case .food:
                guard let targetVal = target else{
                    return ("\(val)" + unit.rawValue)
                }
                return ("\(val) / \(Int(targetVal))") +  unit.rawValue
            case .water:
                guard let targetVal = target else{
                    return ("\(val)" + unit.rawValue)
                }
                return ("\(val) / \(Int(targetVal))") +  unit.rawValue
            case .sleep:
                return (newVal ?? value).convertToTimeString()
            case .none:
                return ""
        }
    }
    
    func getSleepTimeString()-> String{
        return  Date().getTimeFormDate(start: startTimeStamp, end: endTimeStamp)
    }
    
    
    func getSleepStartAngle() -> Double{
        return 0
    }
    
    func getSleepEndAngle() -> Double{
        0.6
    }
}

