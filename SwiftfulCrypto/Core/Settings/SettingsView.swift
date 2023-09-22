//
//  SettingsView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 20/09/2023.
//

import SwiftUI

struct SettingsView: View {
    @State var darkModeEnabled = false
    @State var enableFaceId = false
    @State var enableNotifications = false
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Personal Infomat")){
                    
                }
                
                
            }
            
            
            
           
            
        }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }

                }
            }
            .background(Color.theme.background)
        }
       
    }
}
}

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let imageTintColor: Color
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: imageName)
                    .font(.title2)
                    .imageScale(.large)
                    .foregroundColor(imageTintColor)

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color.theme.accent)
                
                Spacer()
            }
            .frame(height: 48)
            .padding(.leading)
        }
    }
}


struct SettingsToggleRowView: View {
    let imageName: String
    let title: String
    let imageTintColor: Color
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Image(systemName: imageName)
                .font(.title2)
                .imageScale(.large)
                .foregroundColor(imageTintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color.theme.accent)
        }
        .padding(.horizontal)
        .frame(height: 48)
        .background(Color.theme.background)
        .cornerRadius(10)
        .toggleStyle(SwitchToggleStyle(tint: .blue))
    }
}

#Preview {
    SettingsView().preferredColorScheme(.dark)
}





//            VStack{
//                VStack(alignment: .leading, spacing: 12){
//                    Text("Appearance").font(.headline).fontWeight(.semibold)
//
//                    SettingsToggleRowView(imageName: "moon.circle.fill", title: "Dark Mode", imageTintColor: .purple, isOn: $darkModeEnabled)
//
//                }
//                .padding()
//                VStack(alignment: .leading) {
//                    Text("Privacy")
//                        .font(.headline)
//                        .fontWeight(.semibold)
//
//                    VStack {
//                        SettingsToggleRowView(imageName: "faceid",
//                                              title: "Enable Face ID",
//                                              imageTintColor: Color(.darkGray),
//                                              isOn: $enableFaceId)
//
//                        Divider()
//                            .padding(.horizontal)
//
//                        SettingsRowView(imageName: "lock.circle.fill", title: "Password", imageTintColor:Color (.blue))
//                    }
//                    .background(RoundedRectangle(cornerRadius: 10))
//                    .foregroundColor(Color.theme.background)
//
//                }
//                .padding()
//
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Notifications")
//                        .font(.headline)
//                        .fontWeight(.semibold)
//
//                    SettingsToggleRowView(imageName: "bell.circle.fill",
//                                          title: "Push Notifications",
//                                          imageTintColor: Color(.systemPink),
//                                          isOn: $enableNotifications)
//                }
//                .padding()
//
//            }
