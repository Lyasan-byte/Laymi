//
//  UserProfileStorage.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

protocol UserProfileStorage: Sendable {
    func fetchOrCreateProfile(for user: AuthUser) async throws -> UserProfile
    func saveProfile(userId: String, name: String, email: String, birthday: Date, gender: Gender, photoData: Data?) async throws -> UserProfile
    func deleteProfile(userId: String) async throws
}
