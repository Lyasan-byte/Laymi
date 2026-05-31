//
//  JournalViewModel.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

@MainActor
@Observable
final class JournalViewModel {
    private let journalStorage: JournalStorage
    
    var entries: [JournalEntry] = []
    var activeSheet: JournalSheet?
    var viewState: ViewState = .loading
    
    let prompts = JournalPrompt.allCases
    
    init(journalStorage: JournalStorage) {
        self.journalStorage = journalStorage
    }
    
    var isErrorPresented: Bool {
        if case .error = viewState {
            return true
        }
        
        return false
    }
    
    var errorMessage: String {
        if case .error(let message) = viewState {
            return message
        }
        
        return ""
    }
    
    func openCreateSheet(for prompt: JournalPrompt) {
        activeSheet = .create(prompt)
    }
    
    func clearError() {
        viewState = entries.isEmpty ? .empty : .content
    }
    
    func loadEntries() async {
        viewState = .loading
        
        do {
            entries = try await journalStorage.fetchEntries()
            viewState = entries.isEmpty ? .empty : .content
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
    
    func createEntry(prompt: JournalPrompt, text: String, mood: JournalMood) async {
        do {
            entries = try await journalStorage.createEntry(prompt: prompt, text: text, mood: mood)
            viewState = entries.isEmpty ? .empty : .content
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
    
    func deleteEntry(_ entry: JournalEntry) async {
        do {
            entries = try await journalStorage.deleteEntry(entry)
            viewState = entries.isEmpty ? .empty : .content
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
}
