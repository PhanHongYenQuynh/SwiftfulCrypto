//
//  RegistrationView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 18/10/2023.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var Repass = ""
    @State private var isPasswordVisible = false
    @State private var showAlert = false
    @Binding var index : Int
    @EnvironmentObject var viewModel: AuthViewModel
   
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
               
                HStack{
                    
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 10){
                        Text("SignUp")
                            .foregroundColor(self.index == 1 ? .white : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(self.index == 1 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)
                    }
                }
                .padding(.top, 30)
                
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
                        Image(systemName: "person.fill")
                            .foregroundColor(Color.theme.accent)
                        TextField("Full Name", text: self.$fullname)
                    }
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                
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
                    if !password.isEmpty && !isPasswordValid(password) {
                            Text("Password must have 8+ characters with at least one uppercase, one lowercase, one digit, and one special character.")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                VStack{
                    HStack(spacing: 15){
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(Color.theme.accent)
                        }
                        
                        if isPasswordVisible {
                            TextField("Confirm password", text: self.$Repass)
                        } else {
                            SecureField("Confirm password", text: self.$Repass)
                        }
                        if !password.isEmpty && !Repass.isEmpty {
                                if password == Repass {
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.systemGreen))
                                } else {
                                    Image(systemName: "xmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.systemRed))
                                    Text("Passwords do not match.")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                    }
                    Divider().background(Color.white.opacity(0.5))
                    
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                
            }
            .padding()
            // Bottom padding
            .padding(.bottom, 65)
            .background(Color.theme.steel)
            .clipShape(CShape1())
            //clipping the content shape also for tap gesture
            .contentShape(CShape1())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                self.index = 1
            }
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            // Button
            
            Button(action:{
                Task{
                    do {
                       try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                   } catch {
                       showAlert = true
                   }
                }
            }){
                Text("SiGNUP")
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
            //Hiding view when its in background
            // Only button
            .opacity(self.index == 1 ? 1 : 0)
            .preferredColorScheme(.dark)
        }
        .onReceive(viewModel.$signUpError) { error in
            if let error = error {
                showAlert = true
                print("Registration error: \(error.localizedDescription)")
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text("This email is already in use. Please use a different email."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            showAlert = false
        }
    }
}

func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\\$%\\^&\\*\\(\\)_\\-=\\+<>])(?=.*[a-z]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

// MARK: - AuthenticationFormProtocol
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && !password.isEmpty
            && password.count > 8
            && Repass == password
            && !fullname.isEmpty
            && isPasswordValid(password)
    }
}

struct Registration_Previews: PreviewProvider {
    static var previews: some View{
        RegistrationView(index: .constant(1))
            .environmentObject(AuthViewModel())
    }
}
