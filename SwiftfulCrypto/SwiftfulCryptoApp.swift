//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 20/09/2023.
//

import SwiftUI
import Firebase

@main
struct SwiftfulCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView: Bool = true
    @StateObject var viewModel = AuthViewModel()
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            
            ZStack{
                if viewModel.userSession != nil{
                    NavigationView{
                        HomeView()
                            .navigationBarHidden(true)
                            .environmentObject(vm)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                }else{
                    AuthenView()
                }
                
                ZStack{
                    if showLaunchView{
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
            .environmentObject(viewModel)
        }
    }
}


