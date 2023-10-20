//
//  LoginView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 18/10/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var index: Int
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showingAlert = false
    @State private var isPasswordVisible = false
    @State private var showingForgotPassword = false
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                
                HStack{
                    VStack(spacing: 10){
                        Text("Login")
                            .foregroundColor(self.index == 0 ? .white : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(self.index == 0 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.top, 30) // For top curve
                
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color.theme.accent)
                        TextField("Email Address", text: self.$email)
                    }
                    Divider().background(Color.white.opacity(0.5))
                    if !email.isEmpty && !email.contains("@") {
                            Text("Invalid email address.")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                }
                .padding(.horizontal)
                .padding(.top, 40)
     
                VStack{
                    HStack(spacing: 15){
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(Color.theme.accent)
                        }
                        
                        if isPasswordVisible {
                            TextField("Password", text: self.$password)
                        } else {
                            SecureField("Password", text: self.$password)
                        }
                    }
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                HStack{
                    
                    Spacer(minLength: 0)
                    Button(action: {
                        showingForgotPassword.toggle()
                    }){
                        Text("Forget Password?")
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                    .sheet(isPresented: $showingForgotPassword, content: {
                        ForgotPasswordView()
                    })
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
            }
            .padding()
            // Bottom padding
            .padding(.bottom, 65)
            .background(Color.theme.steel)
            .clipShape(CShape())
            .contentShape(CShape())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                self.index = 0
            }
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            // Button
            
            Button(action:{
                Task{
                    do{
                        try await viewModel.signIn(withEmail: email, password: password)
                    }catch{
                        showingAlert = true
                    }
                    
                }
                
            }){
                Text("LOGIN")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color.launch.accent)
                    .clipShape(Capsule())
                    
                    //Shadow
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            //Moving view down
            .offset(y: 25)
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .opacity(self.index == 0 ? 1 : 0)
            .preferredColorScheme(.dark)
        }
        // Handle signInError changes
        .onReceive(viewModel.$signInError) { error in
            if let error = error {
                showingAlert = true
                print("Sign-in error: \(error.localizedDescription)")
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Invalid email or password. Please try again."), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            showingAlert = false // Reset showingAlert when the view appears
        }
    }
}



// MARK - AuthenticationFormProtocol
extension LoginView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 8
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View{
        LoginView(index: .constant(1))
            .environmentObject(AuthViewModel())
    }
}
