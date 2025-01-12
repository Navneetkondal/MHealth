//// 	 
//	SwiftUIWrapper.swift
//	MHealth
//
//	Created By Navneet on 31/12/24
//	


import Foundation
import SwiftUI

struct SwiftUIWrapper<T: View>: UIViewControllerRepresentable {
    let content: () -> T
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: content())
    }
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {}
}
