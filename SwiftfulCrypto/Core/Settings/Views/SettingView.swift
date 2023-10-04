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
    @Binding var darkModeEnabled: Bool
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
                    XMarButton(dismiss: _dismiss)
                }
            }
        }
        
    }
}


struct SettingView_Preview: PreviewProvider{
    static var previews: some View{
        SettingView(darkModeEnabled: .constant(false))
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
                .onChange(of: darkModeEnabled,
                          perform: { _ in
                            SystemThemeManager
                                .shared
                                .handleTheme(darkMode: darkModeEnabled)
                })
            
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
