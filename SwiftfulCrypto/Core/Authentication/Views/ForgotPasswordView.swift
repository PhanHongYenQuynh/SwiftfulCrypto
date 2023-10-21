//
//  ForgotPasswordView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 20/10/2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var fm = ForgotPasswordViewModelImpl(
        service: ForgotPasswordServiceImpl()
    )
    @State private var showAlert = false
    private let cornerRadius: CGFloat = 10
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    VStack(spacing: 10){
                        Text("RESET PASSWORD")
                            .font(.title)
                            .foregroundColor(.accent)
                            .fontWeight(.bold)
                    }
                }

                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "envelope")
                            .foregroundColor(Color.theme.accent)
                        TextField("Email Address", text: $fm.email)
                    }
                    Divider()
                        .background(Color.accent)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color.accent, lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                HStack {
                    
                    Button(action:{
                        fm.sendPasswordReset()
                        showAlert = true
                    }){
                        Text("Send Password Reset")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .padding(.horizontal, 100)
                            .background(Color.launch.accent)
                            .cornerRadius(cornerRadius)
                            //Shadow
                            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Password Reset"),
                            message: Text("Password reset instructions have been sent to your email."),
                            dismissButton: .default(Text("OK")){
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                }
                .padding(.top, 20)
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View{
        ForgotPasswordView()
    }
}
