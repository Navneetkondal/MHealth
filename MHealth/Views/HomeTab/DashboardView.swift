////
//    DashboardView.swift
//    MHealth
//
//    Created By Navneet on 17/11/24
//


import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var viewModel: HealthViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            //Top title View
            TopHeaderView
            //Activity View
            ActivityView
            Spacer()
        }
        .padding(10)
        .background(Color.viewbackground)
        .navigationBarHidden(true)
    }
}

extension DashboardView{
    
    //Top title View
    var TopHeaderView: some View {
        VStack(alignment: .leading){
            Text("Hi, \(viewModel.getFirstName())")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.mlabel)
            
            Text(viewModel.getCurrentDateString())
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color.mlabel)
        }
        .padding(10)
    }
    
    //Activity View
    var ActivityView: some View {
        List{
            ForEach(viewModel.uiViewModel.dashboardUICards,id:  \.id ){ menu in
                MenuHealthActivityView(activity: menu)
            }
            .listRowInsets(.init(top: 15, leading: 5, bottom: 0, trailing: 5))
            .listRowSpacing(10)
            .background(.clear)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .environment(\.defaultMinListRowHeight, 70)
        .listStyle(.plain)
        .ignoresSafeArea(.all)
    }
}
