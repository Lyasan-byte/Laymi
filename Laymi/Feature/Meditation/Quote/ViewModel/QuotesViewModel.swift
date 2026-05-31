//
//  QuotesViewModel.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

@MainActor
@Observable
final class QuotesViewModel {
    private let quoteService: QuoteService
    private let quoteStorage: QuoteStorage
    
    var quotes: [Quote] = []
    var state: ViewState = .loading
    
    var errorPresented: Bool {
        if case .error = state {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case let .error(message) = state {
            return message
        }
        return ""
    }
    
    private let quotesURL = AppConfiguration.quotesURL
    
    init(quoteService: QuoteService, quoteStorage: QuoteStorage) {
        self.quoteService = quoteService
        self.quoteStorage = quoteStorage
    }
    
    func fetchQuotes() async {
        state = .loading
        
        do {
            let cachedQuotes = try await quoteStorage.obtain()
            
            if !cachedQuotes.isEmpty {
                self.quotes = cachedQuotes
            } else {
                let fetchedQuotes = try await quoteService.fetchQuotes(for: quotesURL)
                try await quoteStorage.save(quotes: fetchedQuotes)
                quotes = fetchedQuotes.shuffled()
            }
            
            state = quotes.isEmpty ? .empty : .content
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func clearError() {
        state = quotes.isEmpty ? .empty : .content
    }
}
