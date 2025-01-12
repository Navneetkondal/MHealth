//// 	 
//	HomeTabView.swift
//	MHealth
//
//	Created By Navneet on 15/12/24
//	


import SwiftUI

struct HomeTabView: View {
    @State private var selectedIndex: Int = 0
    var body: some View {
        TabView(selection: $selectedIndex){
            DashboardView()
                .tabItem {
                    Text("Home")
                    Image(systemImg: selectedIndex == 0 ? .sysImg_houseFill : .sysImg_house)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                }.tag(0)
            ProfileView()
                .tabItem {
                    Text("Account")
                    Image(systemImg: selectedIndex == 1 ? .sysImg_personFill : .sysImg_person)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                }.tag(1)
        }
        .onAppear(){
            UITabBar.appearance().unselectedItemTintColor = UIColor.mlabel
        }
        .background(Color.viewbackground)
    }
}
