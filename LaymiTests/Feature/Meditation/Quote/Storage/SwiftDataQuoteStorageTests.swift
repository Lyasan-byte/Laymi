//
//  SwiftDataQuoteStorageTests.swift
//  LaymiTests
//
//  Created by Ляйсан
//

import SwiftData
import Testing
@testable import Laymi

@MainActor
struct SwiftDataQuoteStorageTests {
    @Test func saveAndObtainQuotesRestoresFeedQuotes() async throws {
        let storage = try makeStorage()
        let quotes = [
            Quote(text: "First", author: "A"),
            Quote(text: "Second", author: "B")
        ]
        
        try await storage.save(quotes: quotes)
        let restoredQuotes = try await storage.obtain()
        
        #expect(restoredQuotes == quotes)
    }
    
    @Test func saveQuotesReplacesOldFeedQuotes() async throws {
        let storage = try makeStorage()
        
        try await storage.save(quotes: [Quote(text: "Old", author: "A")])
        try await storage.save(quotes: [Quote(text: "New", author: "B")])
        
        let restoredQuotes = try await storage.obtain()
        
        #expect(restoredQuotes.map(\.text) == ["New"])
    }
    
    @Test func saveAndObtainQuoteOfTheDayIsSeparateFromFeed() async throws {
        let storage = try makeStorage()
        let feedQuote = Quote(text: "Feed quote", author: "Feed")
        let dailyQuote = Quote(text: "Daily quote", author: "Daily")
        
        try await storage.save(quotes: [feedQuote])
        try await storage.saveQuoteOfTheDay(quote: dailyQuote)
        
        #expect(try await storage.obtain() == [feedQuote])
        #expect(try await storage.obtainQuoteOfTheDay() == dailyQuote)
    }
    
    private func makeStorage() throws -> SwiftDataQuoteStorage {
        let container = try ModelContainer(
            for: QuoteEntity.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return SwiftDataQuoteStorage(modelContainer: container)
    }
}
