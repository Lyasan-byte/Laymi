//
//  QuotesViewModelTests.swift
//  LaymiTests
//
//  Created by Ляйсан
//

import Testing
@testable import Laymi

@MainActor
struct QuotesViewModelTests {
    @Test func fetchQuotesUsesCachedQuotes() async {
        let cachedQuote = Quote(text: "Cached quote", author: "Laymi")
        let service = MockQuoteService(result: .success([Quote(text: "Remote quote", author: "API")]))
        let storage = MockQuoteStorage(quotes: [cachedQuote])
        let viewModel = QuotesViewModel(quoteService: service, quoteStorage: storage)
        
        await viewModel.fetchQuotes()
        
        #expect(viewModel.quotes == [cachedQuote])
        #expect(viewModel.state == .content)
        #expect(service.requestedURLs.isEmpty)
    }
    
    @Test func fetchQuotesLoadsAndSavesRemoteQuotesWhenCacheIsEmpty() async throws {
        let remoteQuotes = [
            Quote(text: "First quote", author: "A"),
            Quote(text: "Second quote", author: "B")
        ]
        let service = MockQuoteService(result: .success(remoteQuotes))
        let storage = MockQuoteStorage()
        let viewModel = QuotesViewModel(quoteService: service, quoteStorage: storage)
        
        await viewModel.fetchQuotes()
        
        #expect(viewModel.quotes.count == 2)
        #expect(Set(viewModel.quotes.map(\.text)) == Set(remoteQuotes.map(\.text)))
        #expect(viewModel.state == .content)
        #expect(await storage.savedQuotes == remoteQuotes)
    }
    
    @Test func fetchQuotesShowsEmptyStateWhenNothingIsLoaded() async {
        let service = MockQuoteService(result: .success([]))
        let storage = MockQuoteStorage()
        let viewModel = QuotesViewModel(quoteService: service, quoteStorage: storage)
        
        await viewModel.fetchQuotes()
        
        #expect(viewModel.quotes.isEmpty)
        #expect(viewModel.state == .empty)
    }
    
    @Test func fetchQuotesShowsErrorWhenServiceFails() async {
        let service = MockQuoteService(result: .failure(TestError.expected))
        let storage = MockQuoteStorage()
        let viewModel = QuotesViewModel(quoteService: service, quoteStorage: storage)
        
        await viewModel.fetchQuotes()
        
        #expect(viewModel.state == .error("Test error"))
        #expect(viewModel.errorPresented)
    }
}
