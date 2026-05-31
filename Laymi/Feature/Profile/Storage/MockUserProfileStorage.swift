//
//  MockUserProfileStorage.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

actor MockUserProfileStorage: UserProfileStorage {
    func fetchOrCreateProfile(for user: AuthUser) async throws -> UserProfile {
        await UserProfile.mockUserProfile
    }
    
    func saveProfile(userId: String, name: String, email: String, birthday: Date, gender: Gender, photoData: Data?) async throws -> UserProfile {
        await UserProfile.mockUserProfile
    }
    
    func deleteProfile(userId: String) async throws { }
}
