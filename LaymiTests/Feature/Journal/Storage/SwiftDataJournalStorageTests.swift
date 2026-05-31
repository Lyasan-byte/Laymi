//
//  SwiftDataJournalStorageTests.swift
//  LaymiTests
//
//  Created by Ляйсан
//

import Foundation
import SwiftData
import Testing
@testable import Laymi

@MainActor
struct SwiftDataJournalStorageTests {
    @Test func createEntrySavesAndFetchesEntry() async throws {
        let storage = try makeStorage()
        
        let entries = try await storage.createEntry(
            prompt: .tinyWin,
            text: "I went outside.",
            mood: .calm
        )
        
        #expect(entries.count == 1)
        #expect(entries.first?.prompt == .tinyWin)
        #expect(entries.first?.text == "I went outside.")
    }
    
    @Test func fetchEntriesSortsNewestFirst() async throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let olderEntry = JournalEntry(
            prompt: .gratitudeNote,
            text: "Older",
            mood: .calm,
            createdAt: Date(timeIntervalSince1970: 100)
        )
        let newerEntry = JournalEntry(
            prompt: .tinyWin,
            text: "Newer",
            mood: .happy,
            createdAt: Date(timeIntervalSince1970: 200)
        )
        context.insert(JournalEntryEntity(entry: olderEntry))
        context.insert(JournalEntryEntity(entry: newerEntry))
        try context.save()
        
        let storage = SwiftDataJournalStorage(modelContainer: container)
        let entries = try await storage.fetchEntries()
        
        #expect(entries.map(\.text) == ["Newer", "Older"])
    }
    
    @Test func deleteEntryRemovesSavedEntry() async throws {
        let storage = try makeStorage()
        let entries = try await storage.createEntry(
            prompt: .eveningBrainDump,
            text: "Something to delete",
            mood: .tired
        )
        
        let remainingEntries = try await storage.deleteEntry(entries[0])
        
        #expect(remainingEntries.isEmpty)
    }
    
    private func makeStorage() throws -> SwiftDataJournalStorage {
        try SwiftDataJournalStorage(modelContainer: makeContainer())
    }
    
    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: JournalEntryEntity.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }
}
