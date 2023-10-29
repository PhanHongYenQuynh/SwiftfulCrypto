//
//  AuthViewModel.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 18/10/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn

protocol AuthenticationFormProtocol{
    var formIsValid: Bool {get}
}

enum AuthenticationError: Error{
    case tokenError(message: String)
}

@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var signInError: Error?
    @Published var signUpError: Error?
    @Published var userID: String?
    static let shared = AuthViewModel() 
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws{
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch{
            signInError = error
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("user").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            signUpError = error
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
}
    
    func signOut(){
        do{
            try Auth.auth().signOut() //sign out user on backend
            self.userSession = nil // wipes out user session and takes us back to login screen
            self.currentUser = nil //wipes out current user data model
        }catch{
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async {
        do {
            // Delete user account in Firebase Authentication
            try await Auth.auth().currentUser?.delete()

            // Remove user data from Firestore
            if let currentUser = self.currentUser {
                try await Firestore.firestore().collection("user").document(currentUser.id).delete()
            }

            // Reset user session and current user
            self.userSession = nil
            self.currentUser = nil

        } catch {
            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
        }
    }
        
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        self.userID = uid
        guard let snapshot = try? await Firestore.firestore().collection("user").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func signInWithGoogle() async -> Bool{
        guard let clientID = FirebaseApp.app()?.options.clientID else{
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else{
                print("There is no root view controller")
            return false
        }
        do{
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else{
                throw AuthenticationError.tokenError(message: "ID token missing")
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("User: \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            
            // Update userSession
            self.userSession = firebaseUser
            
            // Update currentUser
            let currentUser = User(id: firebaseUser.uid, fullname: firebaseUser.displayName ?? "Unknown", email: firebaseUser.email ?? "Unknown")
            self.currentUser = currentUser
            
            // Add or update user in Firestore
            do {
                try await Firestore.firestore().collection("user").document(firebaseUser.uid).setData(["fullname": currentUser.fullname, "email": currentUser.email, "id": firebaseUser.uid])
            } catch {
                print("Error saving data to Firestore: \(error.localizedDescription)")
            }
            
            return true
        }
        catch{
            print(error.localizedDescription)
            return false
        }
        return false
    }
    
}


//try await Firestore.firestore().collection("user").document(user.id).setData(encodedUser)
//await fetchUser()
