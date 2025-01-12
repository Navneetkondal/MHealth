////
//	HomeUI.swift
//	MHealth
//
//	Created By Navneet on 08/12/24
//


import Foundation
import SwiftUICore

class DashboardCardData: Identifiable, ObservableObject, Codable {
    @Published var id: Int = 0
    var name: String
    var image: MImageStringEnum
    var type: ActivityTypeEnum
    var otherType: RecordOtherTypeEnum
    var progressBar: ProgressBarEnum
    var isSystemImg, isShowAdd, isShowEnter, isShowValue: Bool
    var buttonType: DashboardButtonType
    var valueAlingment: MUIAlignmentEnum
    var istralingImg =  false
    var trailImg: MImageStringEnum
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(MImageStringEnum.self, forKey: .image)
        self.type = try container.decode(ActivityTypeEnum.self, forKey: .type)
        self.progressBar = try container.decode(ProgressBarEnum.self, forKey: .progressBar)
        self.isSystemImg = try container.decode(Bool.self, forKey: .isSystemImg)
        self.isShowAdd = try container.decode(Bool.self, forKey: .isShowAdd)
        self.isShowEnter = try container.decode(Bool.self, forKey: .isShowEnter)
        self.isShowValue = try container.decode(Bool.self, forKey: .isShowValue)
        self.valueAlingment = try container.decode(MUIAlignmentEnum.self, forKey: .valueAlingment)
        self.otherType = try container.decode(RecordOtherTypeEnum.self, forKey: .otherType)
        self.istralingImg = try container.decode(Bool.self, forKey: .istralingImg)
        self.trailImg = try container.decode(MImageStringEnum.self, forKey: .trailImg)
        self.buttonType = try container.decode(DashboardButtonType.self, forKey: .buttonType)
    }
    
    enum CodingKeys: CodingKey {
        case id, name, image, type, progressBar, isSystemImg, isShowAdd, isShowEnter, isShowValue, valueAlingment, value, istralingImg, trailImg, buttonType, otherType
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.image, forKey: .image)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.progressBar, forKey: .progressBar)
        try container.encode(self.isSystemImg, forKey: .isSystemImg)
        try container.encode(self.isShowAdd, forKey: .isShowAdd)
        try container.encode(self.isShowEnter, forKey: .isShowEnter)
        try container.encode(self.isShowValue, forKey: .isShowValue)
        try container.encode(self.valueAlingment, forKey: .valueAlingment)
        try container.encode(self.istralingImg, forKey: .istralingImg)
        try container.encode(self.trailImg, forKey: .trailImg)
    }
    
    @MainActor func getbuttonName(_ vmModel: HealthViewModel, _ content: String? = nil) -> String{
        if  buttonType != .enter{
            if type == .Sleep{
                return String(format: buttonType.content, "Record")
            }else{
                let unit = vmModel.healthActivitys[type]?.todaysActivity.target.unit ?? .none
                let qnt = vmModel.healthActivitys[type]?.todaysActivity.target.qnt ?? 0
                let str =  "\(Int(qnt)) \(unit.rawValue)"
                return String(format: buttonType.content, content ?? str)
            }
        }else {
            return buttonType.content
        }
    }
    
    func isSetLeadingButtonImg() -> Bool {
        buttonType == .enterWithPlusIconL || buttonType == .customWithPlusIconL
    }
    
    func isSetTrailingButtonImg() -> Bool {
        buttonType == .enterWithPlusIconT || buttonType == .customWithPlusIconT
    }
}
enum DashboardButtonType: Int, Codable{
    case custom = 0
    case enter = 1
    
    case enterWithPlusIconL = 2
    case customWithPlusIconL = 3
    
    case enterWithPlusIconT = 4
    case customWithPlusIconT = 5
    
    case enterWithContentAtT = 6
    case addWithContentAtT = 7
    
    case enterWithContentAtL = 8
    case customWithContentAtL = 9
    
    case noButton = -1
    
    var content: String{
        switch self{
            case .enter, .enterWithPlusIconL, .enterWithPlusIconT:
                return "Enter"
            case .enterWithContentAtT:
                return "Enter %@"
            case .addWithContentAtT:
                return "Add %@"
            case .enterWithContentAtL:
                return "%@ Enter"
            default:
                return "%@"
        }
    }
}
