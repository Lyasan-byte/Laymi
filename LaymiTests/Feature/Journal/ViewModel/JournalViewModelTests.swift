//
//  JournalViewModelTests.swift
//  LaymiTests
//
//  Created by Ляйсан
//

import Testing
@testable import Laymi

@MainActor
struct JournalViewModelTests {
    @Test func loadEntriesShowsContentState() async {
        let entry = JournalEntry(prompt: .tinyWin, text: "I finished my task.", mood: .happy)
        let storage = MockJournalStorage(entries: [entry])
        let viewModel = JournalViewModel(journalStorage: storage)
        
        await viewModel.loadEntries()
        
        #expect(viewModel.entries == [entry])
        #expect(viewModel.viewState == .content)
    }
    
    @Test func loadEntriesShowsEmptyState() async {
        let storage = MockJournalStorage()
        let viewModel = JournalViewModel(journalStorage: storage)
        
        await viewModel.loadEntries()
        
        #expect(viewModel.entries.isEmpty)
        #expect(viewModel.viewState == .empty)
    }
    
    @Test func createEntryAddsData() async {
        let storage = MockJournalStorage()
        let viewModel = JournalViewModel(journalStorage: storage)
        
        await viewModel.createEntry(
            prompt: .gratitudeNote,
            text: "Warm coffee helped.",
            mood: .calm
        )
        
        #expect(viewModel.entries.count == 1)
        #expect(viewModel.entries.first?.prompt == .gratitudeNote)
        #expect(viewModel.entries.first?.text == "Warm coffee helped.")
        #expect(viewModel.viewState == .content)
    }
    
    @Test func deleteEntryRemovesDataAndShowsEmptyState() async {
        let entry = JournalEntry(prompt: .tinyWin, text: "A tiny win", mood: .happy)
        let storage = MockJournalStorage(entries: [entry])
        let viewModel = JournalViewModel(journalStorage: storage)
        
        await viewModel.deleteEntry(entry)
        
        #expect(viewModel.entries.isEmpty)
        #expect(viewModel.viewState == .empty)
    }
    
    @Test func loadEntriesShowsErrorWhenStorageFails() async {
        let storage = MockJournalStorage(error: TestError.expected)
        let viewModel = JournalViewModel(journalStorage: storage)
        
        await viewModel.loadEntries()
        
        #expect(viewModel.viewState == .error("Test error"))
        #expect(viewModel.isErrorPresented)
    }
}
