////
//	MFontConstant.swift
//	MHealth
//
//	Created By Navneet on 15/12/24
//
//


import Foundation
import SwiftUICore

enum MFontConstant{
    case regular10
    case regular11
    case regular12
    case regular13
    case regular14
    case regular15
    case regular16
    case regular17
    case regular18
    case regular19
    case regular20
    case regular21
    case semiBold10
    case semiBold11
    case semiBold12
    case semiBold13
    case semiBold14
    case semiBold15
    case semiBold16
    case semiBold17
    case semiBold18
    case semiBold19
    case semiBold20
    case semiBold21
    case bold10
    case bold11
    case bold12
    case bold13
    case bold14
    case bold15
    case bold16
    case bold17
    case bold18
    case bold19
    case bold20
    case bold21
    
    func setMFont(_ design: Font.Design = .default) -> Font{
        .system(size: 10, weight: .regular, design: design)
    }
    
    var font: Font{
        switch self{
            case .regular10:
                    .system(size: 10, weight: .regular)
            case .regular11:
                    .system(size: 11, weight: .regular)
            case .regular12:
                    .system(size: 12, weight: .regular)
            case .regular13:
                    .system(size: 13, weight: .regular)
            case .regular14:
                    .system(size: 14, weight: .regular)
            case .regular15:
                    .system(size: 15, weight: .regular)
            case .regular16:
                    .system(size: 16, weight: .regular)
            case .regular17:
                    .system(size: 17, weight: .regular)
            case .regular18:
                    .system(size: 18, weight: .regular)
            case .regular19:
                    .system(size: 19, weight: .regular)
            case .regular20:
                    .system(size: 20, weight: .regular)
            case .regular21:
                    .system(size: 21, weight: .regular)
            case .semiBold10:
                    .system(size: 10, weight: .semibold)
            case .semiBold11:
                    .system(size: 11, weight: .semibold)
            case .semiBold12:
                    .system(size: 12, weight: .semibold)
            case .semiBold13:
                    .system(size: 13, weight: .semibold)
            case .semiBold14:
                    .system(size: 14, weight: .semibold)
            case .semiBold15:
                    .system(size: 15, weight: .semibold)
            case .semiBold16:
                    .system(size: 16, weight: .semibold)
            case .semiBold17:
                    .system(size: 17, weight: .semibold)
            case .semiBold18:
                    .system(size: 18, weight: .semibold)
            case .semiBold19:
                    .system(size: 19, weight: .semibold)
            case .semiBold20:
                    .system(size: 17, weight: .semibold)
            case .semiBold21:
                    .system(size: 21, weight: .semibold)
            case .bold10:
                    .system(size: 10, weight: .bold)
            case .bold11:
                    .system(size: 11, weight: .bold)
            case .bold12:
                    .system(size: 12, weight: .bold)
            case .bold13:
                    .system(size: 13, weight: .bold)
            case .bold14:
                    .system(size: 14, weight: .bold)
            case .bold15:
                    .system(size: 15, weight: .bold)
            case .bold16:
                    .system(size: 16, weight: .bold)
            case .bold17:
                    .system(size: 17, weight: .bold)
            case .bold18:
                    .system(size: 18, weight: .bold)
            case .bold19:
                    .system(size: 19, weight: .bold)
            case .bold20:
                    .system(size: 20, weight: .bold)
            case .bold21:
                    .system(size: 21, weight: .bold)
        }
    }
}
