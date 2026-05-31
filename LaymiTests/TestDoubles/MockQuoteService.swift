//
//  MockQuoteService.swift
//  LaymiTests
//
//  Created by Ляйсан
//

@testable import Laymi

final class MockQuoteService: QuoteService {
    var result: Result<[Quote], Error>
    private(set) var requestedURLs: [String] = []
    
    init(result: Result<[Quote], Error>) {
        self.result = result
    }
    
    func fetchQuotes(for url: String) async throws -> [Quote] {
        requestedURLs.append(url)
        return try result.get()
    }
}
