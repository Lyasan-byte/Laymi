//
//  Quote.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

struct Quote: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String
    let author: String
    
    init(id: UUID = UUID(), text: String, author: String) {
        self.id = id
        self.text = text
        self.author = author
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case text = "quote"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.text = try container.decode(String.self, forKey: .text)
        self.author = try container.decode(String.self, forKey: .author)
    }
}

extension Quote {
    static let quotes: [Quote] = [
        Quote(
            text: "The only way to do great work is to love what you do.",
            author: "Steve Jobs"
        ),
        Quote(
            text: "Life is what happens to you while you're busy making other plans.",
            author: "John Lennon"
        ),
        Quote(
            text: "Success is not final, failure is not fatal: it is the courage to continue that counts.",
            author: "Winston Churchill"
        )
    ]
}
