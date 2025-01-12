//// 	 
//	FooterButtonsView.swift
//	MHealth
//
//	Created By Navneet on 11/01/25
//


import SwiftUI

struct FooterButtonsView: View {
    var saveAction: () -> Void
    var cancelAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                cancelAction()
            }) {
                Text("Cancel")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            Button(action: {
                saveAction()
            }) {
                Text("Save")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green4)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
        .padding( 10)
    }
}

