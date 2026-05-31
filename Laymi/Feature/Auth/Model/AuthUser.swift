//
//  AuthUser.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import FirebaseAuth

struct AuthUser: Identifiable, Equatable, Sendable {
    let id: String
    let email: String?
    let name: String?
    let photoUrl: String?
    let gender: String = Gender.male.name
    let dateOfBirth = Date()
    
    var birthday: String {
        dateOfBirth.formatted(.dateTime.month(.wide).day().year())
    }
}

extension AuthUser {
    init(user: FirebaseAuth.User, name: String? = nil) {
        self.init(
            id: user.uid,
            email: user.email,
            name: name ?? user.displayName,
            photoUrl: user.photoURL?.absoluteString
        )
    }
}

extension AuthUser {
    static let mockUser = AuthUser(id: "2", email: "laysan@gmail.com", name: "Laysan", photoUrl: "")
}


enum Gender: String, Identifiable, CaseIterable, Hashable, Sendable {
    case female
    case male
    
    var id: Self { self }
    
    nonisolated var name: String {
        switch self {
        case .female:
            "Female"
        case .male:
            "Male"
        }
    }
    
    nonisolated init?(name: String) {
        switch name {
        case "Female":
            self = .female
        case "Male":
            self = .male
        default:
            return nil
        }
    }
}
