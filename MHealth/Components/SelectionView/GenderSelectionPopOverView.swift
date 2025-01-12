//// 	 
//	GenderSelectionView.swift
//	MHealth
//
//	Created By Navneet on 31/12/24
//	


import SwiftUI

struct GenderSelectionPopOverView<Content: View>: View {
    let content: Content
    let genders: [UserGender] = [.Male, .Female, .Other]
    var actionPerfomed: ((Any) -> Void)?

    init(actionPerfomed: ((Any) -> Void)?, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.actionPerfomed = actionPerfomed
    }
    
    var body: some View {
        Menu {
            ForEach(genders, id: \.self) { gender in
                Button() {
                    if let actionPerfomed = actionPerfomed{
                        actionPerfomed(gender)
                    }
                } label: {
                    Text(gender.rawValue)
                        .foregroundColor(.mlabel)
                        .background(Color.clear)
                        .font(MFontConstant.semiBold14.font)
                }
            }
        } label: {
            content
        }
    }
}
