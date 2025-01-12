////
//	ProfileView.swift
//	MHealth
//
//	Created By Navneet on 16/12/24
//


import SwiftUI
struct ProfileView: View {
    
    @EnvironmentObject var viewModel: HealthViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var router: Router<MHealthNavigationRoute>
    
    var body: some View {
        RoutingView(stack: $router.stack) {
            
            // User Profile View
            UserProfileView
            
            // Personal Best Section
            PersonalBestView
            
            // Weekly Summary Section
           // WeeklySummaryView
            
            // LogoutButton Section
            LogoutButton
            Spacer()
        }
        .background(Color.viewbackground)
        .navigationBarHidden(true)
    }
}

extension ProfileView{
    
    // User Profile View
    var UserProfileView: some View {
        VStack {
            UserView
            
            if let userImage = viewModel.mHealthUser.getUserImage(){
                userImage
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                    .clipShape(.circle)
                    .padding(.top,  -140)
            }else{
                Image(systemImg: .sysImg_personFill)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.viewbackground)
                    .scaleEffect(0.55)
                    .background(Color.imgBackground)
                    .frame(width: 80, height: 80, alignment: .center)
                    .clipShape(.circle)
                    .padding(.top,  -140)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    // User View
    var UserView: some View {
        MReusableCardView(.lightViewBackground, curve: 20){
            VStack(spacing: 10){
                Text(viewModel.getUserName())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mlabel)
                    .padding(.top, 30)
                HStack{
                    Spacer()
                    Button(action: {
                        router.navigate(to: .EditProfile(viewModel.mHealthUser))
                    }) {
                        Text("Edit")
                            .font(.caption)
                            .foregroundColor(Color.mlabel)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.darkGray2)
                            .cornerRadius(15)
                    }
                    .padding(.top, -70)
                    .padding(.trailing, 20)
                }
            }
            .frame(height: 90)
            .frame(maxWidth: .infinity)
        }
        .padding(.top, 60)
    }
    
    // Weekly Summary Section
    var WeeklySummaryView: some View {
        MReusableCardView(.lightViewBackground, curve: 20){
            VStack(alignment: .leading) {
                Text("Weekly summary")
                    .font(.headline)
                
                Text("1–7 December")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 2)
                
                HStack {
                    Text("Average active time")
                    Spacer()
                    Text("0 mins")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
    
    // Personal Best Section
    var PersonalBestView: some View {
        MReusableCardView(.lightViewBackground, curve: 20){
            VStack(alignment: .leading) {
                Text("Personal best")
                    .font(.headline)
                
                Text("No personal bests")
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
    
    var LogoutButton: some View {
        CurvedButtonView(title: "Logout"){
            loginViewModel.removeCredentials()
            router.navigateToRoot()
        }
        .showMToastView(toast: $loginViewModel.toast)
    }
}
