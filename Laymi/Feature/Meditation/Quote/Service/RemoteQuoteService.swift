//
//  RemoteQuoteService.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

final class RemoteQuoteService: QuoteService {
    private let urlSession: URLSession
    
    lazy var decoder = JSONDecoder()
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchQuotes(for url: String) async throws -> [Quote] {
        try await fetch(for: url)
    }
    
    private func fetch<T: Decodable>(for url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: url)
        try handleResponse(data: data, response: response)
        
        return try decoder.decode(T.self, from: data)
    }
    
    private func handleResponse(data: Data, response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw APIError.badStatusCode(response.statusCode)
        }
    }
}

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
            
        case .invalidResponse:
            return "Invalid server response."
            
        case .badStatusCode(let code):
            return "Request failed with status code \(code)."
        }
    }
}
