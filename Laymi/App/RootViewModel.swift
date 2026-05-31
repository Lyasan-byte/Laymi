//
//  RootViewModel.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

enum RootState {
    case loading
    case unauthenticated
    case authenticated(AuthUser)
    case error(String)
}

@Observable
final class RootViewModel {
    var state: RootState = .loading
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func checkAuthState() {
        if let user = authService.currentUser {
            state = .authenticated(user)
        } else {
            state = .unauthenticated
        }
    }
    
    func showMainFlow() {
        checkAuthState()
    }
    
    func showAuthFlow() {
        state = .unauthenticated
    }
    
    var errorMessage: String? {
        if case .error(let message) = state {
            return message
        }
        
        return nil
    }
    
    func clearError() {
        state = .unauthenticated
    }
}
