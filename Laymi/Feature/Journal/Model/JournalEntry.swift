//
//  JournalEntry.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

struct JournalEntry: Identifiable, Equatable, Sendable {
    let id: UUID
    var prompt: JournalPrompt
    var text: String
    var mood: JournalMood
    var createdAt = Date()
    
    var title: String {
        prompt.rawValue
    }
    
    var preview: String {
        return text.trimmed.isEmpty ? "No text yet" : String(text.trimmed.prefix(90)) + "..."
    }
    
    init(
        id: UUID = UUID(),
        prompt: JournalPrompt,
        text: String,
        mood: JournalMood,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.prompt = prompt
        self.text = text
        self.mood = mood
        self.createdAt = createdAt
    }
}

enum JournalMood: String, CaseIterable, Identifiable, Sendable {
    case anxious = "Anxious"
    case lonely = "Lonely"
    case tired = "Tired"
    case frustrated = "Frustrated"
    case sad = "Sad"
    case calm = "Calm"
    case happy = "Happy"
    case relaxed = "Relaxed"
    case overwhelmed = "Overwhelmed"
    
    var id: Self { self }
}

enum JournalPrompt: String, CaseIterable, Identifiable, Sendable {
    case anxietyUnpack = "Anxiety Unpack"
    case lonelinessReflection = "Loneliness Reflection"
    case eveningBrainDump = "Evening Brain Dump"
    case selfCompassionLetter = "Self-Compassion Letter"
    case tinyWin = "Tiny Win"
    case gratitudeNote = "Gratitude Note"
    
    var id: Self { self }
    
    var subtitle: String {
        switch self {
        case .anxietyUnpack:
            return "Separate facts from fears"
        case .lonelinessReflection:
            return "Notice what kind of connection you miss"
        case .eveningBrainDump:
            return "Put down what can wait"
        case .selfCompassionLetter:
            return "Write to yourself gently"
        case .tinyWin:
            return "Find one thing you handled"
        case .gratitudeNote:
            return "Save one small good thing"
        }
    }
    
    var questions: [String] {
        switch self {
        case .anxietyUnpack:
            return [
                "What happened before you started feeling anxious?",
                "What thought is repeating in your mind?",
                "What is a fact, and what is a fear?",
                "What is one tiny next step?"
            ]
        case .lonelinessReflection:
            return [
                "What kind of connection are you missing?",
                "Is there someone safe you could message?",
                "What would feel comforting right now?"
            ]
        case .eveningBrainDump:
            return [
                "What is still on your mind tonight?",
                "What can wait until tomorrow?",
                "What would help your body feel safe before sleep?"
            ]
        case .selfCompassionLetter:
            return [
                "What are you blaming yourself for?",
                "What would you say to someone you love in the same situation?",
                "What do you need to hear right now?"
            ]
        case .tinyWin:
            return [
                "What is one thing you handled today?",
                "What was difficult but you still got through?",
                "What can you thank yourself for?"
            ]
        case .gratitudeNote:
            return [
                "What is one small thing that felt good?",
                "Who or what helped you today?",
                "How can you keep this feeling close?"
            ]
        }
    }
}
