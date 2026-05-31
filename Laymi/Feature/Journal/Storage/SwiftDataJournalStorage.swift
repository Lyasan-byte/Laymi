//
//  SwiftDataJournalStorage.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import SwiftData

actor SwiftDataJournalStorage: JournalStorage {
    private let modelContainer: ModelContainer
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    func fetchEntries() async throws -> [JournalEntry] {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<JournalEntryEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        return try context.fetch(descriptor).map(\.journalEntry)
    }
    
    func createEntry(prompt: JournalPrompt, text: String, mood: JournalMood) async throws -> [JournalEntry] {
        let context = ModelContext(modelContainer)
        let entry = JournalEntry(prompt: prompt, text: text, mood: mood)
        let entity = JournalEntryEntity(entry: entry)
        context.insert(entity)
        try context.save()
        
        return try await fetchEntries()
    }
    
    func deleteEntry(_ entry: JournalEntry) async throws -> [JournalEntry] {
        let context = ModelContext(modelContainer)
        let entryId = entry.id
        let descriptor = FetchDescriptor<JournalEntryEntity>(
            predicate: #Predicate { $0.id == entryId }
        )
        
        if let entity = try context.fetch(descriptor).first {
            context.delete(entity)
            try context.save()
        }
        
        return try await fetchEntries()
    }
}
