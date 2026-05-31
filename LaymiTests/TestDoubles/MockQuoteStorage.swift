//
//  MockQuoteStorage.swift
//  LaymiTests
//
//  Created by Ляйсан
//

@testable import Laymi

actor MockQuoteStorage: QuoteStorage {
    var quotes: [Quote]
    var quoteOfTheDay: Quote?
    var error: Error?
    private(set) var savedQuotes: [Quote] = []
    private(set) var savedQuoteOfTheDay: Quote?
    
    init(quotes: [Quote] = [], quoteOfTheDay: Quote? = nil, error: Error? = nil) {
        self.quotes = quotes
        self.quoteOfTheDay = quoteOfTheDay
        self.error = error
    }
    
    func save(quotes: [Quote]) throws {
        if let error { throw error }
        self.quotes = quotes
        savedQuotes = quotes
    }
    
    func obtain() throws -> [Quote] {
        if let error { throw error }
        return quotes
    }
    
    func saveQuoteOfTheDay(quote: Quote) async throws {
        if let error { throw error }
        quoteOfTheDay = quote
        savedQuoteOfTheDay = quote
    }
    
    func obtainQuoteOfTheDay() async throws -> Quote? {
        if let error { throw error }
        return quoteOfTheDay
    }
}
