////
//	LoginViewModel.swift
//	MHealth
//
//	Created By Navneet on 21/12/24
//


import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isPassVisisble = false
    @Published var isLoading = false
    @Published var authState = UserAuthState()
    
    @Published var toast: Toast? = nil
    
    @Published var isLogined = false
    @Published var isEmailValid = true
    @Published var isPassValid = true
    @Published var isValidSignIn = false
    var isReloginChecked = false
    private var publishers = Set<AnyCancellable>()
    
    var userProfile: MHealthUser?
    private let usecase: LoginUseCase
    
    init(service: LoginUseCase = LoginService()) {
        usecase = service
        Task{
            await isRelogin()
        }
        isUserEmailValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isEmailValid, on: self)
            .store(in: &publishers)
        isPasswordValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isPassValid, on: self)
            .store(in: &publishers)
        isSignInFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValidSignIn, on: self)
            .store(in: &publishers)
    }
    
    var isUserEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .map { email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }
    
    var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { password in
                return password.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    var isSignInFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(
            isUserEmailValidPublisher,
            isPasswordValidPublisher)
        .map { isEmailValid, isPasswordValid in
            return isEmailValid && isPasswordValid
        }
        .eraseToAnyPublisher()
    }
    
    func updateLoginStatus(_ state: AuthState){
        authState.currentState = state
        isLogined = state == .authorised
    }
    
    func loginUser(isRelogin: Bool = false, emailId: String? = nil, passwd: String? = nil,  _ completion: @escaping (() -> Void)) {
        guard !isLoading else { return }
        Task {
            do {
                let responseModel = try await usecase.verify(with: LoginModel(email: emailId ?? email, pass: passwd ?? password))
                if responseModel.isRegistered{
                    self.userProfile = responseModel.user
                    //self.authState.currentState = .authorised
                    self.updateLoginStatus(.authorised)
                    setSavedEmailId(responseModel.user?.email)
                    setSavedPassword(responseModel.user?.password)
                    completion()
                }else{
                    self.updateLoginStatus(.unauthorised)
                   // self.authState.currentState = .unauthorised
                }
                isLoading = false
                if !isRelogin{
                    toast = .init(style:  responseModel.isRegistered ? .success : .error, message: responseModel.msg.rawValue)
                }
            } catch {
                isLoading = false
            }
        }
    }
    
    @discardableResult
    func isRelogin() async  -> Bool{
        let obj = Task{
            try await Task.sleep(nanoseconds: 1000000000)
            guard !isReloginChecked, let email = getSavedEmailId(), let passwd = getSavedPassword(), !email.isEmpty && !passwd.isEmpty else {
                self.updateLoginStatus(.unauthorised)
                self.isReloginChecked = true
                objectWillChange.send()
                return false
            }
            print("Method called 1")
            self.isReloginChecked = true
            loginUser(isRelogin: true, emailId: email, passwd:passwd) {}
            return true
        }
        return (try? await obj.value) ?? false
    }
    
    func getSavedEmailId() -> String?{
        UserDefaults.standard.string(forKey: "email")
    }
    
    func getSavedPassword() -> String?{
        UserDefaults.standard.string(forKey:"password")
    }
    
    func removeCredentials(){
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        updateLoginStatus(.unauthorised)
        toast = Toast(style: .success, message: "You have successfully logged out!!")
    }
    
    func setSavedEmailId(_ email: String?){
        UserDefaults.standard.set(email, forKey: "email")
    }
    
    func setSavedPassword(_ password: String?){
        UserDefaults.standard.set(password, forKey: "password")
    }
    
    func setLoggedInState(){
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    
    var hasPersistedSignedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
}

struct LoginModel: Codable {
    let email: String
    let pass: String
}

struct LoginResponseModel {
    let user: MHealthUser?
    let msg: LoginMsgEnum
    let isRegistered: Bool
    
    enum LoginMsgEnum: String{
        case LoginSuccessFull = "Login SuccessFully"
        case FailedToLogin = "User not found. \n Please check Email / Password"
        
        var isError: Bool{
            switch self{
                case .LoginSuccessFull:
                    return false
                case .FailedToLogin:
                    return true
            }
        }
    }
}

protocol LoginUseCase: AnyObject {
    func verify(with model: LoginModel) async throws -> LoginResponseModel
}

class LoginService: LoginUseCase {
    
    func verify(with model: LoginModel) async throws -> LoginResponseModel {
        // try await Task.sleep(nanoseconds: 5000000000)
        if  let user = DBUtils.getUserProfile().first(where: { $0.email.lowercased() == model.email.lowercased() &&  $0.password != nil && $0.password! == model.pass}){
            print((user.email) + " >>> "  + (user.password ?? ""))
            return LoginResponseModel(user: user, msg: .LoginSuccessFull , isRegistered: true )
        }else{
            return LoginResponseModel(user: nil,msg: .FailedToLogin , isRegistered: false)
        }
    }
}

class UserAuthState: ObservableObject {
    @Published var currentState: AuthState = .none
}

public enum AuthState:Int {
    case unauthorised = 0
    case authorised = 1
    case none = 3
}
