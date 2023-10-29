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
import AuthenticationServices
import CryptoKit

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
    @Published var errorMessage = ""
    private var currentNonce: String?
    static let shared = AuthViewModel()
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    // MARK: - PUBLIC
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
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
      }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        }
        else if case .success(let authorization) = result {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetdch identify token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                Task {
                    do {
                        let result = try await Auth.auth().signIn(with: credential)
                        
                        // Update userSession
                        self.userSession = result.user
                        
                        // Update currentUser
                        let currentUser = User(id: result.user.uid, fullname: result.user.displayName ?? "Unknown", email: result.user.email ?? "Unknown")
                        self.currentUser = currentUser

                        // Add or update user in Firestore
                        do {
                            try await Firestore.firestore().collection("user").document(result.user.uid).setData(["fullname": currentUser.fullname, "email": currentUser.email, "id": result.user.uid])
                        } catch {
                            print("Error saving data to Firestore: \(error.localizedDescription)")
                        }

                    } catch {
                        print("Error authenticating: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    
    // MARK: - PRIVATE
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}


