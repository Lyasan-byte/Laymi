//
//  QuoteService.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

protocol QuoteService {
    func fetchQuotes(for url: String) async throws -> [Quote]
}
