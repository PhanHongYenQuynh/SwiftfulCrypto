//
//  AuthViewModel.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 18/10/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol{
    var formIsValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var signInError: Error?
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
    
    
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws {
        do {
            let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
            let authResult = try await Auth.auth().signIn(with: credential)
            self.userSession = authResult.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to sign in with Google with error \(error.localizedDescription)")
            throw error
        }
    }
}


