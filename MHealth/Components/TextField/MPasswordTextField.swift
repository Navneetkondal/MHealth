//// 	 
//	MPasswordTextField.swift
//	MHealth
//
//	Created By Navneet on 21/12/24
//
//


import SwiftUI

struct MPasswordTextField: View {
    
    var isPasswordTextField: Bool = false
    var placeholder: String
    @Binding var isPassVisisble: Bool
    @Binding var text: String
    @Binding var isValid: Bool
    
    var body: some View {
        if isPasswordTextField{
            HStack(spacing: 15){
                VStack{
                    if isPassVisisble {
                        TextField(placeholder, text: $text)
                            .autocapitalization(.none)
                    } else {
                        SecureField(placeholder, text:  $text)
                            .autocapitalization(.none)
                    }
                }
                Button(action: {
                    isPassVisisble.toggle()
                }) {
                    Image(systemImg: isPassVisisble ? .sysImg_eye : .sysImg_eyeSlash)
                        .foregroundColor(Color.mlabel)
                        .opacity(0.8)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 6)
                .stroke(text.isEmpty || isValid ? .blue : .red,lineWidth: 2))
            .padding(.top, 10)
        } else {
            TextField(placeholder,text: $text)
                .autocapitalization(.none)
                .padding()
                .background(RoundedRectangle(cornerRadius: 6)
                    .stroke(text.isEmpty || isValid ? .blue : .red,lineWidth: 2))
                .padding(.top, 0)
        }
    }
}
