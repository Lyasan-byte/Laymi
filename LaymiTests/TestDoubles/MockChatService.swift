//
//  MockChatService.swift
//  LaymiTests
//
//  Created by Ляйсан
//

@testable import Laymi

final class MockChatService: ChatService {
    var chunks: [String]
    var error: Error?
    
    init(chunks: [String] = [], error: Error? = nil) {
        self.chunks = chunks
        self.error = error
    }
    
    func sendMessageStream(_ text: String) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            if let error {
                continuation.finish(throwing: error)
                return
            }
            
            chunks.forEach { continuation.yield($0) }
            continuation.finish()
        }
    }
}
