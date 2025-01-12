//// 	 
//	ErrorException.swift
//	MHealth
//
//	Created By Navneet on 29/12/24
//	


import Foundation

@MainActor
struct ErrorException:LocalizedError, Identifiable {
    let title: String?
    let msg: String
    let id: UUID
    let type: ErrorExceptionTypeEnum
    
    init(id: UUID = UUID(), title: String?, msg: String?, type: ErrorExceptionTypeEnum = .none) {
        self.id = id
        self.title = title
        self.msg = msg ?? "Something went wrong"
        self.type = type
    }
}

enum ErrorExceptionTypeEnum{
    case info
    case success
    case error
    case warning
    case none
}
