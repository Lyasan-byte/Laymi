//
//  SwiftDataUserProfileStorage.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import SwiftData

actor SwiftDataUserProfileStorage: UserProfileStorage {
    private let modelContainer: ModelContainer
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    func fetchOrCreateProfile(for user: AuthUser) async throws -> UserProfile {
        let context = ModelContext(modelContainer)
        
        if let profile = try fetchProfile(userId: user.id, context: context) {
            return profile.profile
        }
        
        let profile = UserProfileEntity(
            id: user.id,
            email: user.email ?? "",
            name: user.name ?? "",
            birthday: user.dateOfBirth,
            genderName: user.gender
        )
        
        context.insert(profile)
        try context.save()
        return profile.profile
    }
    
    func saveProfile(
        userId: String,
        name: String,
        email: String,
        birthday: Date,
        gender: Gender,
        photoData: Data?
    ) async throws -> UserProfile {
        let context = ModelContext(modelContainer)
        
        guard let profile = try fetchProfile(userId: userId, context: context) else {
            throw AuthError.missingCurrentUser
        }
        
        profile.name = name
        profile.email = email
        profile.birthday = birthday
        profile.genderName = gender.name
        profile.photoData = photoData
        profile.updatedAt = Date()
        
        try context.save()
        return profile.profile
    }
    
    func deleteProfile(userId: String) async throws {
        let context = ModelContext(modelContainer)
        
        guard let profile = try fetchProfile(userId: userId, context: context) else {
            return
        }
        
        context.delete(profile)
        try context.save()
    }
    
    private func fetchProfile(userId: String, context: ModelContext) throws -> UserProfileEntity? {
        let descriptor = FetchDescriptor<UserProfileEntity>(
            predicate: #Predicate { $0.id == userId }
        )
        
        return try context.fetch(descriptor).first
    }
}
