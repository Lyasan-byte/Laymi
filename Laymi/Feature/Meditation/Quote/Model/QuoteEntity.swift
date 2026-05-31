//
//  QuoteEntity.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftData
import Foundation

@Model
final class QuoteEntity {
    var id: UUID
    var text: String
    var author: String
    
    var savedAt: Date
    var cacheTypeRawValue: String
    
    init(quote: Quote, cacheType: CacheType) {
        self.id = quote.id
        self.text = quote.text
        self.author = quote.author
        self.savedAt = Date()
        self.cacheTypeRawValue = cacheType.rawValue
    }
    
    var quote: Quote {
        Quote(id: id, text: text, author: author)
    }
    
    var cacheType: CacheType? {
        CacheType(rawValue: cacheTypeRawValue)
    }
}

enum CacheType: String, Codable {
    case quotesFeed
    case quoteOfTheDay
}
