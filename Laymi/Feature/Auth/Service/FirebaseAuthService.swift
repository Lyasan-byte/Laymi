//
//  FirebaseAuthService.swift
//  Laymi
//
//  Created by Ляйсан
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

final class FirebaseAuthService: AuthService {
    var currentUser: AuthUser? {
        Auth.auth().currentUser.map { AuthUser(user: $0) }
    }
    
    func signIn(email: String, password: String) async throws -> AuthUser {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthUser(user: result.user)
    }
    
    func signUp(email: String, password: String, name: String) async throws -> AuthUser {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
        
        return AuthUser(user: result.user, name: name)
    }
    
    func signInWithGoogle() async throws -> AuthUser {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.missingClientID
        }
        
        guard let rootViewController = UIApplication.shared.rootViewController else {
            throw AuthError.missingRootViewController
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.missingGoogleToken
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
        let authResult = try await Auth.auth().signIn(with: credential)
        let user = AuthUser(user: authResult.user)
        return user
    }
    
    func signOut() throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async throws {
        guard let firebaseUser = Auth.auth().currentUser else {
            throw AuthError.missingCurrentUser
        }
        
        try await firebaseUser.delete()
        GIDSignIn.sharedInstance.signOut()
    }
}

enum AuthError: LocalizedError {
    case missingClientID
    case missingRootViewController
    case missingGoogleToken
    case missingCurrentUser
    
    var errorDescription: String? {
        switch self {
        case .missingClientID:
            return "Google Sign-In is not configured."
        case .missingRootViewController:
            return "Unable to open Google Sign-In."
        case .missingGoogleToken:
            return "Google Sign-In did not return a valid token."
        case .missingCurrentUser:
            return "No signed in user found."
        }
    }
}

private extension UIApplication {
    var rootViewController: UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
