//
//  MockChatService.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

final class MockChatService: ChatService {
    func sendMessageStream(_ text: String) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                let response = "I hear you. Let’s slow this down together for a moment."

                for word in response.split(separator: " ") {
                    try? await Task.sleep(for: .milliseconds(80))
                    continuation.yield(String(word) + " ")
                }

                continuation.finish()
            }
        }
    }
}
