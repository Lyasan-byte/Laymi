//
//  JournalEntryEntity.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import SwiftData

@Model
final class JournalEntryEntity {
    @Attribute(.unique) var id: UUID
    var promptRawValue: String
    var text: String
    var moodRawValue: String
    var createdAt: Date
    
    init(entry: JournalEntry) {
        self.id = entry.id
        self.promptRawValue = entry.prompt.rawValue
        self.text = entry.text
        self.moodRawValue = entry.mood.rawValue
        self.createdAt = entry.createdAt
    }
    
    var journalEntry: JournalEntry {
        JournalEntry(
            id: id,
            prompt: JournalPrompt(rawValue: promptRawValue) ?? .anxietyUnpack,
            text: text,
            mood: JournalMood(rawValue: moodRawValue) ?? .calm,
            createdAt: createdAt
        )
    }
}
