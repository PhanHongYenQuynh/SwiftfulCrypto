//
//  SettingView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 21/09/2023.
//

import SwiftUI

struct SettingView: View {
    
    @State private var Email = ""
    @State private var Password = ""
    @State private var darkModeEnabled = false
    @State private var selectedLanguage = ""
    @State private var enableNotifications = false
    @State private var languages = ["English", "Spanish", "French", "German"]
    @State private var selectedLanguageIndex = 0
    
    let privacyPolicy = URL(string: "https://www.coingecko.com/en/privacy")!
    let termsofService = URL(string: "https://www.coingecko.com/en/terms")!
    let disclaimer = URL(string: "https://www.coingecko.com/en/disclaimer")!
    
    
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
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    XMarButton()
                }
            }
        }
        
    }
}


struct SettingView_Preview: PreviewProvider{
    static var previews: some View{
        SettingView()
    }
}

extension SettingView{
    private var myaccount: some View{
        Section(header: Text("My Account")){
            TextField("Email", text: $Email)
            TextField("Password", text: $Password)
        }
    }
    
    private var appsettings: some View{
        Section(header: Text("App Settings")){
            Toggle("Dark Mode", isOn: $darkModeEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .green))
            
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
