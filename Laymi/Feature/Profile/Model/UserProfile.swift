//
//  UserProfile.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

struct UserProfile: Identifiable, Equatable, Sendable {
    let id: String
    var email: String
    var name: String
    var birthday: Date
    var gender: Gender
    var photoData: Data?
}

extension UserProfile {
    static let mockUserProfile = UserProfile(
        id: "1",
        email: "laysan@gmail.com",
        name: "Laysan",
        birthday: Date(),
        gender: .female
    )
}
