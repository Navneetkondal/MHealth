////
//    HealthActivity.swift
//    MHealth
//
//    Created By Navneet on 17/11/24
//

import Foundation
import SwiftUI

class HealthActivity: Identifiable, Codable, Equatable , ObservableObject{
    var id: UUID = UUID()
    var prevActivity: [HealthDetail]
    var message: String?
    var image: String?
    var name: String?
    var typeId: ActivityTypeEnum
    @Published var todaysActivity: HealthDetail
    @Published var attributedTitle: AttributedString = ""
    
    
    enum CodingKeys: String, CodingKey {
        case id, todaysActivity, prevActivity, message, image, name, typeId
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID(uuidString: try container.decodeIfPresent(String.self, forKey: .id) ?? "") ?? UUID()
        self.todaysActivity = try container.decodeIfPresent(HealthDetail.self, forKey: .todaysActivity) ?? .init(date: nil, target: .init(target: 0, unit: .none, activityType: .none), value: 0.0)
        self.prevActivity = try container.decodeIfPresent([HealthDetail].self, forKey: .prevActivity) ?? []
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.typeId = try container.decodeIfPresent(ActivityTypeEnum.self, forKey: .typeId)  ?? .none
    }
    
    func getFoodDishes(for dish: MealTypeEnum? = nil) -> [FoodDetail]{
        var dishes: [FoodDetail] = []
        if let dish = dish{
            if let dishes = todaysActivity.meals.first(where: { $0.mealType == dish}) {
                return dishes.meals
            }
        }else{
            todaysActivity.meals.forEach({ items in
                dishes.append(contentsOf:  items.meals)
            })
        }
        return dishes
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.todaysActivity, forKey: .todaysActivity)
        try container.encodeIfPresent(self.prevActivity, forKey: .prevActivity)
        try container.encodeIfPresent(self.message, forKey: .message)
        try container.encodeIfPresent(self.image, forKey: .image)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.typeId, forKey: .typeId)
    }
    
    static func == (lhs: HealthActivity, rhs: HealthActivity) -> Bool {
        return lhs.id == rhs.id &&
        lhs.prevActivity == rhs.prevActivity &&
        lhs.todaysActivity == rhs.todaysActivity &&
        lhs.message == rhs.message &&
        lhs.image == rhs.image &&
        lhs.name == rhs.name &&
        lhs.typeId == rhs.typeId
    }
    
    
    func getTitleWithAttributedString(_ newVal: Double? = nil, newTarget: Double? = nil) -> AttributedString{
        let unit = self.todaysActivity.target.unit?.rawValue ?? ""
        let target = Int(newTarget ?? self.todaysActivity.target.target ?? 0)
        let title = String(Int((newVal ?? todaysActivity.value)))
        switch typeId{
            case .Steps:
                return attributedString([title] ,colors: [.mlabel], font: [.bold17])
            case .Food:
                let strings = [title ,"/\(target) \(unit)"]
                return attributedString(strings, colors: [.mlabel, .darkGray2], font: [.bold14, .semiBold13])
            case .Water:
                let strings = [title ,"/\(target) \(unit)"]
                return attributedString(strings, colors: [.mlabel, .darkGray2], font: [.bold14, .semiBold13])
            case .Sleep:
                let strings = [Double((todaysActivity.value) * 60).stringFromTimeInterval() ]
                return attributedString(strings, colors: [.mlabel, .darkGray2], font: [.bold14, .semiBold13])
            case .none:
                return AttributedString("")
        }
    }
    
    func attributedString(_ strings: [String], colors: [Color], font: [MFontConstant]) -> AttributedString{
        var combination = AttributedString()
        strings.enumerated().forEach({(index, value) in
            var attributedString = AttributedString(value)
            attributedString.font =  font[index].font
            attributedString.foregroundColor = colors[index]
            combination.append(attributedString)
        })
        return combination
    }
}

extension Double{
    func stringFromTimeInterval() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .default
        formatter.allowedUnits = [.minute]
        if self > 3600{
            formatter.allowedUnits.insert(.hour)
        }
        if self > 86400{
            formatter.allowedUnits.insert(.day)
        }
        return formatter.string(from: self) ?? ""
    }
}

