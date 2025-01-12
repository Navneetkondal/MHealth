//
//  Extenstion + View.swift
//  Heal
//
//  Created by Navneet on 19/09/2023.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    @MainActor
    func errorAlert(isPresented:Binding<Bool>, error: ErrorException?, buttonTitle: String = "OK") -> some View {
        return alert("", isPresented: isPresented) {
            Button {
                print("AlertCancel")
            } label: {
                Text(buttonTitle)
            }
        } message: {
            Text(error?.msg ?? "Something Went wrong")
        }
    }
}
