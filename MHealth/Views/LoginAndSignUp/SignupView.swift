////
//	SignupView.swift
//	MHealth
//
//	Created By Navneet on 21/12/24
//


import SwiftUI

struct SignupView: View {
    
    @StateObject var signUpViewModel: SignUpViewModel = .init()
    @EnvironmentObject var router: Router<MHealthNavigationRoute>
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @State var activeSheet: ActiveBSType?

    var body: some View{
        GeometryReader{_ in
            ScrollView {
                VStack(alignment: .center ,spacing: 10){
                    Text("Sign up a new account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.mlabel)
                        .padding(.top, 15)
                    
                    // First name Textfield View
                    FirstNameTextfieldView
                    
                    // Last name Textfield View
                    LastNameTextfieldView
                    
                    HStack{
                        // DOB Selection View
                        DOBSelectionView
                        // Gender Selection View
                        GenderSelectionView
                            .padding(.leading, 10)
                    }
                    
                    // Email Textfield View
                    EmailTextfieldView
                    
                    // Password Textfield View
                    PasswordTextfieldView
                    
                    // Confirm Password Textfield View
                    ConfirmPasswordTextfieldView
                    
                    // Sign up button
                    SignUpButtonView
                    
                    Spacer()
                }
                .showMToastView(toast: $signUpViewModel.toast)
            }
        }
        .frame(maxHeight: .infinity)
        .padding([.leading, .trailing], 15)
        .background(Color.lightViewBackground)
    }
}

//MARK: - TextField View
extension SignupView{
    
    // First Name Textfield View
    var FirstNameTextfieldView: some View {
        MPasswordTextField(isPasswordTextField: false, placeholder: "Name", isPassVisisble: .constant(false), text: $signUpViewModel.firstName, isValid: $signUpViewModel.isFirstNameValid)
            .submitLabel(.next)
    }
    
    // Last Name Textfield View
    var LastNameTextfieldView: some View {
        MPasswordTextField(isPasswordTextField: false, placeholder: "Last Name", isPassVisisble: .constant(false), text: $signUpViewModel.lastName, isValid: $signUpViewModel.isLastNameValid)
            .submitLabel(.next)
    }

    // Email Textfield View
    var EmailTextfieldView: some View {
        MPasswordTextField(isPasswordTextField: false, placeholder: "Email", isPassVisisble: .constant(false), text: $signUpViewModel.userEmail, isValid: $signUpViewModel.isEmailValid)
            .submitLabel(.next)
    }
    
    // Password Textfield View
    var PasswordTextfieldView: some View {
        MPasswordTextField(isPasswordTextField: true, placeholder: "Password", isPassVisisble: $signUpViewModel.isPassVisisble, text: $signUpViewModel.password, isValid: $signUpViewModel.isPassValid)
            .submitLabel(.next)
    }
    
    // Confirm Password Textfield View
    var ConfirmPasswordTextfieldView: some View {
        MPasswordTextField(isPasswordTextField: true, placeholder: "Confirm Password", isPassVisisble: $signUpViewModel.isRePassVisisble, text: $signUpViewModel.repeatedPassword, isValid: $signUpViewModel.isrepeatedPassValid)
            .submitLabel(.done)
    }
}

//MARK: - DOB Selection View
extension SignupView{
    var DOBSelectionView: some View {
        HStack(alignment: .center){
            Button{
                activeSheet = .DOB
            } label: {
                Text("DOB")
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold15.font)
                    .frame(width: 50, alignment: .center)
                
                Divider()
                    .padding([.top, .bottom], 8)
                    .padding([.leading, .trailing], 2)
                    .frame(width: 1, height: 60)
                
                Text(signUpViewModel.dobStr)
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold14.font)
                Spacer()
            }
        }
        .padding([.leading], 5)
        .background(RoundedRectangle(cornerRadius:6).stroke(.blue,lineWidth:2))
        .background(Color.btnBackground)
        
        .sheet(item: $activeSheet) { item in
            switch item {
                case .DOB:
                    //Date Picker BS
                    DatePickerView(title: "Select Birthday", actionPerfomed: datePickerActionPerformed)
                        .presentationDetents([.height(300)])
                        .presentationCornerRadius(15)
                        .presentationDragIndicator(.hidden)
            }
        }
    }
}

//MARK: - Gender View
extension SignupView{
    
    var GenderSelectionView: some View {
        GenderSelectionPopOverView(actionPerfomed: genderSelectionActionPerformed){
            HStack{
                Text("Gender")
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold15.font)
                    .padding(.leading, 5)
                Divider()
                    .padding([.top, .bottom], 8)
                    .padding([.leading, .trailing], 2)
                    .frame(width: 1, height: 60)
                
                Text(signUpViewModel.sex)
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.bold14.font)
                Spacer()
            }
            .padding([.leading, .trailing], 5)
            .frame(width: 150, height: 60, alignment: .center)
            .background(RoundedRectangle(cornerRadius:6).stroke(.blue,lineWidth:2))
            .background(Color.btnBackground)
        }
    }
}

//MARK: - Signup button
extension SignupView{
    //Signup button View
    var SignUpButtonView: some View {
        Button(action: {
            signUpViewModel.registerUser(){
                router.navigateBack()
            }
        }) {
            Text("Sign up")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
        }
        .background(Color.blue)
        .cornerRadius(6)
        .padding(.top, 15)
        .opacity(signUpViewModel.isValidSignUP ? 1 : 0.5)
        .disabled(!signUpViewModel.isValidSignUP)
    }
}

//MARK: - DOB BottomSheet and Gender Selection Callback
extension SignupView{
    
    // DOB BottomSheet Callback Section
    func datePickerActionPerformed(date: Date, type: DatePickerView.DatePickerConstant){
        signUpViewModel.dobStr = date.getDateStringFromUTC(.EEEddMMMyyyy)
        signUpViewModel.birthDate = date
    }
    
    // Gender Selection Callback Section
    func genderSelectionActionPerformed(value: Any){
        if let gender = value as? UserGender{
            signUpViewModel.sex = gender.rawValue
        }
    }
}

//MARK: - Bottom Sheet Constant
extension SignupView{
    
    enum ActiveBSType: Identifiable {
        case DOB
        
        var id: Int {
            hashValue
        }
    }
}

