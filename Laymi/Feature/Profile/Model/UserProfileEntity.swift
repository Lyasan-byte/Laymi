//
//  UserProfileEntity.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import SwiftData

@Model
final class UserProfileEntity {
    @Attribute(.unique) var id: String
    var email: String
    var name: String
    var birthday: Date
    var genderName: String
    var photoData: Data?
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: String,
        email: String,
        name: String,
        birthday: Date = Date(),
        genderName: String = Gender.male.name,
        photoData: Data? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.birthday = birthday
        self.genderName = genderName
        self.photoData = photoData
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var profile: UserProfile {
        UserProfile(
            id: id,
            email: email,
            name: name,
            birthday: birthday,
            gender: Gender(name: genderName) ?? .male,
            photoData: photoData
        )
    }
}
