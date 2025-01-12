////
//	HealthTarget.swift
//	MHealth
//
//	Created By Navneet on 08/12/24
//


import Foundation

class HealthTarget:Identifiable, Codable, Equatable{
    var target: Double?
    var unit: ActivityUnitsEnum?
    var name: String?
    var qnt: Double? = 0
    var activityType: ActivityTypeEnum = .none
    
    init(){
    }
    
    init(name: String? = nil, target: Double, unit: ActivityUnitsEnum, activityType: ActivityTypeEnum) {
        self.target = target
        self.unit = unit
        self.name = name ?? ""
        self.activityType = activityType
    }
    
    enum CodingKeys: String, CodingKey {
        case target, unit, name, qnt, activityType
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.qnt = try container.decode(Double?.self, forKey: .qnt)
        self.target = try container.decode(Double.self, forKey: .target)
        self.unit = try container.decode(ActivityUnitsEnum.self, forKey: .unit)
        self.name = try container.decode(String.self, forKey: .name)
        self.activityType = try container.decode(ActivityTypeEnum.self, forKey: .activityType)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.target, forKey: .target)
        try container.encode(self.unit, forKey: .unit)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.qnt, forKey: .qnt)
        try container.encode(self.activityType, forKey: .activityType)
    }
    
    func getFormattedStringValue() -> String{
        String(format: "%.2f", target ?? 0)
    }
    
    static func == (lhs: HealthTarget, rhs: HealthTarget) -> Bool {
        return lhs.target == rhs.target &&
        lhs.unit == rhs.unit &&
        lhs.name == rhs.name &&
        lhs.target == rhs.target
    }
}
