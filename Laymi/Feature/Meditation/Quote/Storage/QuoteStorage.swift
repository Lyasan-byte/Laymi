//
//  QuoteStorage.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

protocol QuoteStorage: Sendable {
    func save(quotes: [Quote]) async throws
    func obtain() async throws -> [Quote]
    
    func saveQuoteOfTheDay(quote: Quote) async throws
    func obtainQuoteOfTheDay() async throws -> Quote?
}
