//// 	 
//	MHealthApp.swift
//	MHealth
//
//	Created By Navneet on 14/12/24
//
//


import SwiftUI


@main
struct MHealthApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var healthViewModel: HealthViewModel
    @StateObject var loginViewModel: LoginViewModel
    @StateObject var router: Router<MHealthNavigationRoute> = .init()

    init() {
        self._healthViewModel = StateObject(wrappedValue: HealthViewModel())
        self._loginViewModel = StateObject(wrappedValue: LoginViewModel())
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                    .environmentObject(router)
                    .environmentObject(loginViewModel)
                    .environmentObject(healthViewModel)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .transition(.opacity)
                    .preferredColorScheme(.dark)
        }
    }
}
