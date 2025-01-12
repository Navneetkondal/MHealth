////
//    HealthProfile.swift
//    MHealth
//
//    Created By Navneet on 17/11/24
//


import Foundation
import HealthKit
import Combine
import SwiftUI
import UIKit

class MHealthUser: Identifiable, Codable, ObservableObject, Hashable {
    
    var id: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var gender: String
    var dob: TimeInterval!
    var password: String? = ""
    var img: Data?
    @Published var nickname: String = ""
    @Published var height: Double? = 0
    @Published var weight: Double? = 0
    @Published var weightUnit: WeightUnitsEnum = .kg
    @Published var heightUnit: HeightUnitsEnum = .cm
    var timezoneIdentifier: String = "UTC"
    
    var targets: [HealthTarget]
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, email, gender, dob, password, healthProfile, nickname , healthTarget, height,weight, weightUnit, heightUnit, img, targets
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? "User"
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        self.email = try container.decode(String.self, forKey: .email)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.dob = try container.decode(TimeInterval.self, forKey: .dob)
        self.password = try container.decode(String.self, forKey: .password)
        self.img = try container.decode(Data.self, forKey: .img)
        self.height = try container.decode(Double.self, forKey: .height)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.weightUnit = try container.decode(WeightUnitsEnum.self, forKey: .weightUnit)
        self.heightUnit = try container.decode(HeightUnitsEnum.self, forKey: .heightUnit)
        self.targets = try container.decode([HealthTarget].self, forKey: .targets)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.gender, forKey: .gender)
        try container.encodeIfPresent(self.dob, forKey: .dob)
        try container.encodeIfPresent(self.password, forKey: .password)
        try container.encodeIfPresent(self.nickname, forKey: .nickname)
        try container.encodeIfPresent(self.height, forKey: .height)
        try container.encodeIfPresent(self.weight, forKey: .weight)
        try container.encodeIfPresent(self.weightUnit, forKey: .weightUnit)
        try container.encodeIfPresent(self.heightUnit, forKey: .heightUnit)
        try container.encodeIfPresent(self.img, forKey: .img)
        try container.encodeIfPresent(self.targets, forKey: .targets)
    }
    
    init(id: String = UUID().uuidString, firstName: String, lastName: String, email: String, gender: String, dob: TimeInterval, password: String = "", img: Data? = Data(), targets:[HealthTarget]) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.gender = gender
        self.dob = dob
        self.password = password
        self.img = img
        self.targets = targets
    }
    
    var timeZone: TimeZone{
        .init(identifier: timezoneIdentifier) ?? .gmt
    }
    
    func getUserName() -> String{
        firstName + " " + lastName
    }
    
    func getHeightString() -> String{
        let height =  (height ?? 0)
        let unit = heightUnit
        return height == 0 ? "" : unit == .cm ? "\(height) \(unit.rawValue)" :"\( "\(height)".replacingOccurrences(of: ".", with: ",")) \(unit.rawValue)"
    }
    
    func getWeightString() -> String{
        let weight =  (weight ?? 0)
        let unit = weightUnit
        return weight == 0 ? "" :  "\(weight) \(unit.rawValue)"
    }
    
    func getUserImage() -> Image?{
        if let img = img,let uiImg = UIImage(data: img){
            return Image(uiImage: uiImg)
        }
        return nil
    }
    
    func getUserDateOfBirth() -> Date?{
        dob.getDateFromTimeStamp()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(nickname)
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(email)
        hasher.combine(gender)
        hasher.combine(dob)
        hasher.combine(password)
    }
    
    static func == (lhs: MHealthUser, rhs: MHealthUser) -> Bool {
        return  lhs.id == rhs.id && lhs.nickname == rhs.nickname && lhs.firstName == rhs.firstName && lhs.email == rhs.email && lhs.gender == rhs.gender && lhs.dob == rhs.dob && lhs.password == rhs.password
    }
}

extension HKBiologicalSex {
    var stringValue: String {
        switch self {
            case .notSet: return "Not Set"
            case .female: return "Female"
            case .male: return "Male"
            case .other: return "Other"
            @unknown default: return "Unknown"
        }
    }
}

extension HKBloodType {
    var stringValue: String {
        switch self {
            case .notSet: return "Not Set"
            case .aPositive: return "A+"
            case .aNegative: return "A-"
            case .bPositive: return "B+"
            case .bNegative: return "B-"
            case .abPositive: return "AB+"
            case .abNegative: return "AB-"
            case .oPositive: return "O+"
            case .oNegative: return "O-"
            @unknown default: return "Unknown"
        }
    }
}
