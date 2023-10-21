//
//  AuthenView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 18/10/2023.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthenView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State var index = 0
    var body: some View {
        GeometryReader {_ in
            
            VStack{
                Image("logo-transparent")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 50)
                
                ZStack{
                    RegistrationView(index: self.$index)
                    //Change view order
                        .zIndex(Double(self.index))
                    LoginView(index: self.$index)
                }
                
                HStack(spacing: 15){
                    
                    Rectangle()
                        .fill(Color.theme.accent)
                        .frame(height: 1)
                    
                    Text("OR")
                    
                    Rectangle()
                        .fill(Color.theme.accent)
                        .frame(height: 1)
                }
                .padding(.horizontal, 20)
                .padding(.top, 25)
                //because login button is moved 25 in y axis and 25 padding = 50
                
                HStack(spacing: 25){
                    
                    Button(action: {
                        
                        
                    }){
                        Image("apple")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        Task{
                            do{
                                try await viewModel.signInWithGoogle()
                            }catch{
                                print(error)
                            }
                        }
                    }){
                        Image("google")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    
                }
                .padding(.top, 30)
            }
            .padding(.vertical)
        }
        .background(Color.launch.background).edgesIgnoringSafeArea(.all)
        .preferredColorScheme(.dark)
            
    }
}

struct CShape : Shape{
    func path(in rect: CGRect) -> Path {
        return Path{path in
            
            //Right side curve
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}
struct CShape1 : Shape{
    func path(in rect: CGRect) -> Path {
        return Path{path in
            
            //left side curve
            path.move(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}


struct AuthView_Previews: PreviewProvider {
    static var previews: some View{
        AuthenView()
            .environmentObject(AuthViewModel())
    }
}
