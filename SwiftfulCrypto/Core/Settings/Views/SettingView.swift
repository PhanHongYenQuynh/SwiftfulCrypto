//
//  SettingView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 21/09/2023.
//

import SwiftUI

struct SettingView: View {
    
  
    @Environment(\.dismiss) var dismiss
    @State private var Email = ""
    @State private var Password = ""
    
    // Interface Style
    @State private var buttonRect: CGRect = .zero
    @StateObject private var appSettings = AppSettings()
    
    // Current & Previous State Images
    @State private var currentImage: UIImage?
    @State private var previousImage: UIImage?
    @State private var maskAnimation: Bool = false
    
    @State private var selectedLanguage = ""
    @State private var enableNotifications = false
    @State private var languages = ["English", "Spanish", "French", "German"]
    @State private var selectedLanguageIndex = 0
 
    let privacyPolicy = URL(string: "https://www.coingecko.com/en/privacy")!
    let termsofService = URL(string: "https://www.coingecko.com/en/terms")!
    let disclaimer = URL(string: "https://www.coingecko.com/en/disclaimer")!
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            List{
                myaccount
                appsettings
                orthers
                signout
            
            }
            .font(.headline)
            .accentColor(.accent)
            .navigationTitle("Settings")
        }
        
        // DarkMode
        .createImages(
            toggleDarkMode: appSettings.toggleDarkMode,
            currentImage: $currentImage,
            previousImage: $previousImage,
            activateDarkMode: appSettings.$activateDarkMode)
        .overlay(content: {
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                if let previousImage, let currentImage{
                    ZStack{
                        Image(uiImage: previousImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                        
                        Image(uiImage: currentImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                            .mask(alignment: .topLeading){
                                Circle()
                                    .frame(width: buttonRect.width * (maskAnimation ? 80 : 1), height: buttonRect.height * (maskAnimation ? 80 : 1), alignment: .bottomLeading)
                                    .frame(width: buttonRect.width, height: buttonRect.height)
                                    .offset(x: buttonRect.minX, y: buttonRect.minY)
                                    .ignoresSafeArea()
                            }
                    }
                    .task {
                        guard !maskAnimation else { return }
                        withAnimation(.easeInOut(duration: 0.9), completionCriteria: .logicallyComplete){
                            maskAnimation = true
                        }completion: {
                            // Removing all snapshots
                            self.currentImage = nil
                            self.previousImage = nil
                            maskAnimation = false
                        }
                    }
                }
            })
            // Reverse Masking
            .mask({
                Rectangle()
                    .overlay(alignment: .topLeading){
                        Circle()
                            .frame(width: buttonRect.width, height: buttonRect.height)
                            .offset(x: buttonRect.minX, y: buttonRect.minY)
                            .blendMode(.destinationOut)
                    }
            })
            .ignoresSafeArea()
        })
        .overlay(alignment: .topTrailing){
            Button(action: {
                appSettings.toggleDarkMode.toggle()
            }, label: {
                Image(systemName: appSettings.toggleDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.title2)
                    .foregroundStyle(Color.primary)
                    .symbolEffect(.bounce, value: appSettings.toggleDarkMode)
                    .frame(width: 40, height: 40)
            })
            .rect{ rect in
                buttonRect = rect
            }
            .padding(10)
            .disabled(currentImage != nil || previousImage != nil || maskAnimation)
        }
        .preferredColorScheme(appSettings.activateDarkMode ? .dark : .light)
    }
}


struct SettingView_Preview: PreviewProvider{
    static var previews: some View{
        SettingView()
    }
}

// MARK: EXTENSION

extension SettingView{
    private var myaccount: some View{
        Section(header: Text("My Account")){
            TextField("Email", text: $Email)
            TextField("Password", text: $Password)
        }
    }
    
    private var appsettings: some View{
        Section(header: Text("App Settings")){
            Toggle("Notifications", isOn: $enableNotifications)
                .toggleStyle(SwitchToggleStyle(tint: .green))
            
            
            Picker("Language", selection: $selectedLanguageIndex) {
                    ForEach(0..<languages.count) {
                        Text(languages[$0])
                    }
                }
                .pickerStyle(MenuPickerStyle())
        }
        
    }
    
    private var orthers: some View{
        Section(header: Text("Orthers")){
            Link("Privacy Policy", destination: privacyPolicy)
            Link("Terms of Service", destination: termsofService)
            Link("Disclaimer", destination: disclaimer)
        }
        
    }
    
    private var signout: some View{
        Section {
            Button(action: {
                
            }) {
                Text("Sign out")
                    .font(.title3)
                    .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity, maxHeight: 10)
            .padding()
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        
    }
}
