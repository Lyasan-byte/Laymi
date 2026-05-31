//
//  MockJournalStorage.swift
//  LaymiTests
//
//  Created by Ляйсан
//

@testable import Laymi

actor MockJournalStorage: JournalStorage {
    var entries: [JournalEntry]
    var error: Error?
    
    init(entries: [JournalEntry] = [], error: Error? = nil) {
        self.entries = entries
        self.error = error
    }
    
    func fetchEntries() async throws -> [JournalEntry] {
        if let error { throw error }
        return entries
    }
    
    func createEntry(prompt: JournalPrompt, text: String, mood: JournalMood) async throws -> [JournalEntry] {
        if let error { throw error }
        let entry = await MainActor.run {
            JournalEntry(prompt: prompt, text: text, mood: mood)
        }
        entries.insert(entry, at: 0)
        return entries
    }
    
    func deleteEntry(_ entry: JournalEntry) async throws -> [JournalEntry] {
        if let error { throw error }
        let entryId = await MainActor.run {
            entry.id
        }
        let currentEntries = entries
        entries = await MainActor.run {
            currentEntries.filter { $0.id != entryId }
        }
        return entries
    }
}
