//
//  MockQuoteStorage.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

actor MockQuoteStorage: QuoteStorage {
    func save(quotes: [Quote]) async throws {
    }
    
    func obtain() async throws -> [Quote] {
        []
    }
    
    func saveQuoteOfTheDay(quote: Quote) async throws {
    }
    
    func obtainQuoteOfTheDay() async throws -> Quote? {
        await Quote(text: "Small steps still count.", author: "Laymi")
    }
}
