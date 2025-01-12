//// 	 
//	SearbarUIKIT.swift
//	MHealth
//
//	Created By Navneet on 12/01/25
//


import SwiftUI
import UIKit

struct SearbarUIKIT: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $searchbarText, placeholder: "Search")
    }
    
    @Binding var searchbarText: String
    @Binding var placeholderVal: String
    
    class Coordinator : NSObject, UISearchBarDelegate{
        @Binding var searchbarValue: String
        var placeholderVal: String
        
        init(text: Binding<String>, placeholder: String){
            _searchbarValue = text
            placeholderVal = placeholder
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchbarValue = searchText
        }
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchbar  = UISearchBar(frame: .zero)
        searchbar.placeholder = placeholderVal
        searchbar.searchBarStyle = .minimal
        
        searchbar.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchbar.searchTextField.heightAnchor.constraint(equalToConstant: 40),
            searchbar.searchTextField.leadingAnchor.constraint(equalTo: searchbar.leadingAnchor, constant: 10),
            searchbar.searchTextField.trailingAnchor.constraint(equalTo: searchbar.trailingAnchor, constant: -10),
            searchbar.searchTextField.centerYAnchor.constraint(equalTo: searchbar.centerYAnchor, constant: 0)
        ])
        
        searchbar.searchTextField.backgroundColor = UIColor.darkGray2
        searchbar.searchTextField.layer.cornerRadius = 20
        searchbar.searchTextField.leftViewMode = .never
        searchbar.searchTextField.leftView = nil
        searchbar.searchTextField.layer.masksToBounds = true
        searchbar.delegate = context.coordinator
        return searchbar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = searchbarText
    }
    
    typealias UIViewType = UISearchBar
}
