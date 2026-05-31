//
//  JournalStorage.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

protocol JournalStorage: Sendable {
    func fetchEntries() async throws -> [JournalEntry]
    func createEntry(prompt: JournalPrompt, text: String, mood: JournalMood) async throws -> [JournalEntry]
    func deleteEntry(_ entry: JournalEntry) async throws -> [JournalEntry]
}
