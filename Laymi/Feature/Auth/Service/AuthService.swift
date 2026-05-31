//
//  AuthService.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

protocol AuthService {
    var currentUser: AuthUser? { get }
    
    func signIn(email: String, password: String) async throws -> AuthUser
    func signUp(email: String, password: String, name: String) async throws -> AuthUser
    func signInWithGoogle() async throws -> AuthUser
    func signOut() throws
    func deleteAccount() async throws
}
