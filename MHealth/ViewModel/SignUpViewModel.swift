////
//	SignUpViewModel.swift
//	MHealth
//
//	Created By Navneet on 21/12/24
//


import Foundation
import Combine

final class SignUpViewModel: ObservableObject {
    
    // Input values from view
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var birthDate = Date.now
    @Published var dobStr =  Date.now.getDateStringFromUTC(.EEEddMMMyyyy)
    @Published var sex: String = ""
    @Published var userEmail = ""
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published var isPassVisisble = false
    @Published var isRePassVisisble = false
    
    @Published var isFirstNameValid = true
    @Published var isLastNameValid = true
    @Published var isEmailValid = true
    @Published var isPassValid = true
    @Published var isrepeatedPassValid = true
    
    @Published var isValidSignUP = false
    @Published var isSuccessFullyRegistered = false
    
    @Published var isLoading = false
    
    @Published var toast: Toast? = nil
    
    private var publishers = Set<AnyCancellable>()
    
    private let usecase: SignUpUseCase
    
    init(service: SignUpUseCase = SignUpService()) {
        usecase = service
        isFirstNameValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFirstNameValid, on: self)
            .store(in: &publishers)
        isLastNameValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isLastNameValid, on: self)
            .store(in: &publishers)
        isUserEmailValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isEmailValid, on: self)
            .store(in: &publishers)
        isPasswordValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isPassValid, on: self)
            .store(in: &publishers)
        isRepeatedPasswordValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isrepeatedPassValid, on: self)
            .store(in: &publishers)
        isSignupFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValidSignUP, on: self)
            .store(in: &publishers)
    }
    
    var isFirstNameValidPublisher: AnyPublisher<Bool, Never> {
        $firstName
            .map { name in
                return name.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    var isLastNameValidPublisher: AnyPublisher<Bool, Never> {
        $lastName
            .map { name in
                return name.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    var isUserEmailValidPublisher: AnyPublisher<Bool, Never> {
        $userEmail
            .map { email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }
    
    var isGenderValidPublisher: AnyPublisher<Bool, Never> {
        $sex
            .map { gender in
                print(UserGender(rawValue: gender) != nil)
                return UserGender(rawValue: gender) != nil
            }
            .eraseToAnyPublisher()
    }
    
    var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { password in
                let regex = "(?=[^a-z]*[a-z])(?=[^0-9]*[0-9])[a-zA-Z0-9!@#$%^&*]{8,}"
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
                return emailPredicate.evaluate(with: password)
            }
            .eraseToAnyPublisher()
    }
    
    var isRepeatedPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $repeatedPassword
            .map { rePass in
                let regex = "(?=[^a-z]*[a-z])(?=[^0-9]*[0-9])[a-zA-Z0-9!@#$%^&*]{8,}"
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
                return emailPredicate.evaluate(with: rePass) && self.password == rePass
            }
            .eraseToAnyPublisher()
    }
    
    var passwordMatchesPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $repeatedPassword)
            .map { password, repeated in
                return password == repeated
            }
            .eraseToAnyPublisher()
    }
    
    var isSignupFormValidPublisher: AnyPublisher<Bool, Never> {
        let isValid = Publishers.CombineLatest4(
            isFirstNameValidPublisher,
            isLastNameValidPublisher,
            isUserEmailValidPublisher,
            isPasswordValidPublisher)
            .map { isNameValid, isEmailValid, isPasswordValid, passwordMatches in
                return isNameValid && isEmailValid && isPasswordValid && passwordMatches
            }
            .eraseToAnyPublisher()
        
        return Publishers.CombineLatest3(
            isValid,
            isGenderValidPublisher,
            passwordMatchesPublisher)
        .map { isValid, isGenderValid, passwordMatches in
            return isValid &&  isGenderValid && passwordMatches
        }
        .eraseToAnyPublisher()
    }
    
    
    func registerUser(_ completion: @escaping (() -> Void)){
        let targets = MHealthUtils.returnModelObjFromLocalJson("DefaultTargets", [HealthTarget].self) ?? []
        let birthDate = birthDate.getTimeStampFromDateUTC()
        let user =  MHealthUser(firstName: firstName, lastName: lastName, email: userEmail, gender:  sex, dob: birthDate, password: password, targets: targets)
        Task {
            do {
                let responseModel = try await usecase.verifyAndRegisterMUser(with: user)
                print(responseModel.msg)
                Task{@MainActor in
                    if responseModel.isRegistered{
                        self.isSuccessFullyRegistered = true
                        completion()
                    }else{
                        self.isSuccessFullyRegistered = false
                    }
                    isLoading = false
                    toast = Toast(style: responseModel.isRegistered ? .success : .error, message: responseModel.msg.rawValue)
                }
            } catch {
                isLoading = false
            }
        }
    }
}

struct SignUpResponseModel: Codable {
    let user: MHealthUser?
    let isRegistered: Bool
    let msg : SignupMsgsEnum
}

enum SignupMsgsEnum: String, Codable{
    case successfull = "User successfully regisetred!!!"
    case failed = "Something Went wrong, Please try again!!!"
    case alreadyExisted = "User already existed with this email!!"
    
    var isError: Bool{
        switch self{
            case .successfull:
                return true
            case .failed, .alreadyExisted:
                return false
        }
    }
}

protocol SignUpUseCase: AnyObject {
    func verifyAndRegisterMUser(with model: MHealthUser) async throws -> SignUpResponseModel
}

class SignUpService: SignUpUseCase {
    
    func verifyAndRegisterMUser(with model: MHealthUser) async throws -> SignUpResponseModel {
        try await Task.sleep(nanoseconds: 500_000_000)
        let users = DBUtils.getUserProfile()
        if let existedUser = users.first(where: { $0.email.lowercased() == model.email.lowercased() &&  $0.password != nil && $0.password! == model.password}){
            existedUser.password = nil
            return SignUpResponseModel(user: existedUser, isRegistered: false, msg: .alreadyExisted)
        }else if DBUtils.saveUserProfile(model).isSaved{
            return SignUpResponseModel(user: model, isRegistered: true, msg: .successfull)
        }else{
            return SignUpResponseModel(user: nil, isRegistered: false, msg: .failed)
        }
    }
}
