//
//  AuthViewModel.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

@MainActor
@Observable
final class AuthViewModel {
    var authService: AuthService
    
    var name = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    var isLoading = false
    var errorMessage: String?
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    var isLoginValid: Bool {
        isValidEmail &&
        password.trimmed.count >= 8
    }
    
    var isSignUpValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        isValidEmail &&
        password.trimmed.count >= 8 &&
        password == confirmPassword
    }
    
    var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }
    
    func signIn() async -> Bool {
        await performAuthAction {
            _ = try await authService.signIn(email: email.trimmed, password: password)
        }
    }
    
    func signUp() async -> Bool {
        await performAuthAction {
            _ = try await authService.signUp(email: email.trimmed, password: password, name: name.trimmed)
        }
    }
    
    func signInWithGoogle() async -> Bool {
        await performAuthAction {
            _ = try await authService.signInWithGoogle()
        }
    }
    
    func clearInput() {
        self.name = ""
        self.email = ""
        self.password = ""
        self.confirmPassword = ""
        self.errorMessage = nil
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    private func performAuthAction(_ action: () async throws -> Void) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await action()
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
