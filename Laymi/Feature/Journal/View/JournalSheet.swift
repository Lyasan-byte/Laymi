//
//  JournalSheet.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

enum JournalSheet: Identifiable {
    case create(JournalPrompt)
    
    var id: String {
        switch self {
        case .create(let prompt):
            return "create-\(prompt.rawValue)"
        }
    }
}
