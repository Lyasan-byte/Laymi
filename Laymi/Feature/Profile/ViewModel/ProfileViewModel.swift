//
//  ProfileViewModel.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

@MainActor
@Observable
final class ProfileViewModel {
    private let authService: AuthService
    private let profileStorage: UserProfileStorage
    
    var name = ""
    var email = ""
    var birthday = Date()
    var gender = Gender.male
    var selectedPhotoData: Data?
    var isLoading = false
    var errorMessage: String?
    
    var birthdayText: String {
        birthday.formatted(.dateTime.month(.wide).day().year())
    }
    
    init(authService: AuthService, profileStorage: UserProfileStorage) {
        self.authService = authService
        self.profileStorage = profileStorage
    }
    
    func configure(with user: AuthUser) async {
        do {
            let profile = try await profileStorage.fetchOrCreateProfile(for: user)
            apply(profile)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func saveProfile() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let userId = try currentUserId()
            let profile = try await profileStorage.saveProfile(
                userId: userId,
                name: name.trimmed,
                email: email,
                birthday: birthday,
                gender: gender,
                photoData: selectedPhotoData
            )
            apply(profile)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func updatePhoto(_ data: Data?) async {
        selectedPhotoData = data
        await saveProfile()
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    func signOut() -> Bool {
        errorMessage = nil
        
        do {
            try authService.signOut()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func deleteAccount() async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let userId = try currentUserId()
            try await authService.deleteAccount()
            try await profileStorage.deleteProfile(userId: userId)
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    private func apply(_ profile: UserProfile) {
        name = profile.name
        email = profile.email
        birthday = profile.birthday
        gender = profile.gender
        selectedPhotoData = profile.photoData
    }
    
    private func currentUserId() throws -> String {
        guard let userId = authService.currentUser?.id else {
            throw AuthError.missingCurrentUser
        }
        
        return userId
    }
}
