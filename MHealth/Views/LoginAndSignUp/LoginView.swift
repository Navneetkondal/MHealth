////
//	LoginView.swift
//	MHealth
//
//	Created By Navneet on 21/12/24
//


import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var router: Router<MHealthNavigationRoute>
    @EnvironmentObject var healthViewModel: HealthViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel

    var body: some View{
        RoutingView(stack: $router.stack) {
            if loginViewModel.authState.currentState == .none || loginViewModel.authState.currentState == .authorised {
                LogoOverLayView
            } else if loginViewModel.authState.currentState == .authorised{
                TabOverLayView
            }else{
                LoginOverLayView
            }
        }
        .onAppear(){
            loginViewModel.isPassVisisble = false
        }
        .onReceive(loginViewModel.authState.$currentState){isLogin in
            if isLogin == .authorised{
                healthViewModel.registerHealthServices(loginViewModel.userProfile)
                router.navigate(to: .HomeTab)
            }
        }
        .showMToastView(toast:  $loginViewModel.toast)        
    }
}

extension LoginView{
    var TabOverLayView: some View {
        VStack(alignment: .center){
            HomeTabView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.lightViewBackground)
    }
}

extension LoginView{
    var LogoOverLayView: some View {
        VStack(alignment: .center){
            Image(img: .healthcareCloud)
                .resizable()
                .frame(width: 255, height: 255.0, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.lightViewBackground)
    }
}

extension LoginView{
    var LoginOverLayView: some View {
        ScrollView{
            VStack(alignment: .center ,spacing: 10){
                Image(img: .healthcareCloud)
                    .resizable()
                    .frame(width: 255, height: 255.0, alignment: .top)
                
                Text("Sign in to your Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 15)
                
                //Email Textfield View
                EmailTextFieldView
                
                //Password Textfield View
                PasswordTextFieldView
                
                //Login button View
                LoginButtonView
                
                //Sign up Label View
                SignUpLabelView
            }
            .frame(maxHeight: .infinity)
            .padding([.leading, .trailing], 15)
            .ignoresSafeArea()
            .background(Color.lightViewBackground)
        }
        .background(Color.lightViewBackground)
    }
}

extension LoginView{
    
    //Email Textfield View
    var EmailTextFieldView: some View {
        MPasswordTextField(isPasswordTextField: false, placeholder: "Email", isPassVisisble: .constant(false), text: $loginViewModel.email, isValid: $loginViewModel.isEmailValid)
            .submitLabel(.next)
    }
    
    //Password Textfield View
    var PasswordTextFieldView: some View {
        MPasswordTextField(isPasswordTextField: true, placeholder: "Password", isPassVisisble: $loginViewModel.isPassVisisble, text: $loginViewModel.password, isValid: $loginViewModel.isPassValid)
            .submitLabel(.done)
    }
    
    //Login button View
    var LoginButtonView: some View {
        Button(action: {
            loginViewModel.loginUser(){}
        }) {
            Text("Login")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
        }
        .background(Color.blue)
        .opacity(loginViewModel.isValidSignIn ? 1 : 0.5)
        .disabled(!loginViewModel.isValidSignIn)
        .cornerRadius(6)
        .padding(.top, 15)
    }
    
    //Sign up Label View
    var SignUpLabelView: some View {
        HStack(spacing: 5){
            Text("Don't have an account ?")
            
            Text("Sign up")
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
                .onTapGesture {
                    print("Sign up")
                    router.navigate(to: .Signup)
                }
            Text("now").multilineTextAlignment(.leading)
        }
        .padding(.top, 25)
    }
}
