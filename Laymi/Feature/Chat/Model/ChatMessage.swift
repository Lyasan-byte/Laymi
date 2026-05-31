//
//  ChatMessage.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let role: ChatRole
    var text: String
}

enum ChatRole {
    case user
    case assistant
}
