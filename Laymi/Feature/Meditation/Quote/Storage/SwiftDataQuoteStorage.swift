//
//  SwiftDataQuoteStorage.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftData
import Foundation

actor SwiftDataQuoteStorage: QuoteStorage {
    private let modelContainer: ModelContainer
    
    private let quotesTTL: TimeInterval = 6 * 60 * 60
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    func save(quotes: [Quote]) throws {
        let context = try fetchAndDeleteOldData(for: .quotesFeed)
        
        let quoteEntities = quotes.map { QuoteEntity(quote: $0, cacheType: .quotesFeed) }
        
        quoteEntities.forEach { context.insert($0) }
        try context.save()
    }
    
    func obtain() throws -> [Quote] {
        return try obtainData(
            for: .quotesFeed,
            ttl: quotesTTL
        )
        .map(\.quote)
    }
    
    func saveQuoteOfTheDay(quote: Quote) async throws {
        let context = try fetchAndDeleteOldData(for: .quoteOfTheDay)
        
        context.insert(QuoteEntity(quote: quote, cacheType: .quoteOfTheDay))
        try context.save()
    }
    
    func obtainQuoteOfTheDay() async throws -> Quote? {
        let context = ModelContext(modelContainer)
        let cacheTypeRawValue = CacheType.quoteOfTheDay.rawValue
        
        let quoteEntities = try context.fetch(
            FetchDescriptor<QuoteEntity>(
                predicate: #Predicate {
                    $0.cacheTypeRawValue == cacheTypeRawValue
                }
            )
        )
        
        guard let quoteEntity = quoteEntities.first else {
            return nil
        }
        
        let isSavedToday = Calendar.current.isDateInToday(quoteEntity.savedAt)
        
        if !isSavedToday {
            quoteEntities.forEach { context.delete($0) }
            try context.save()
            return nil
        }
        
        return quoteEntity.quote
    }
    
    private func fetchAndDeleteOldData(for cacheType: CacheType) throws -> ModelContext {
        let context = ModelContext(modelContainer)
        let cacheTypeRawValue = cacheType.rawValue
        
        let oldQuotes = try context.fetch(
            FetchDescriptor<QuoteEntity>(
                predicate: #Predicate {
                    $0.cacheTypeRawValue == cacheTypeRawValue
                })
        )
        oldQuotes.forEach { context.delete($0) }
        return context
    }
    
    private func obtainData(for cacheType: CacheType, ttl: TimeInterval) throws -> [QuoteEntity] {
        let context = ModelContext(modelContainer)
        let cacheTypeRawValue = cacheType.rawValue
        
        let quoteEntities = try context.fetch(
            FetchDescriptor<QuoteEntity>(
                predicate: #Predicate {
                    $0.cacheTypeRawValue == cacheTypeRawValue
                }
            )
        )
        
        guard let quoteEntity = quoteEntities.first else {
            return []
        }
        
        let isExpired = Date().timeIntervalSince(quoteEntity.savedAt) > ttl
        if isExpired {
            quoteEntities.forEach { context.delete($0) }
            try context.save()
            return []
        }
        return quoteEntities
    }
}
