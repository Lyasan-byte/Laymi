//
//  ChatViewModel.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

@MainActor
@Observable
final class ChatViewModel {
    private let chatService: ChatService
    
    var input = ""
    var isResponding = false
    var messages: [ChatMessage] = [
        ChatMessage(
            role: .assistant,
            text: "Hi, I am here. You can say what you feel, even if it is messy."
        )
    ]
    var errorMessage: String?
    
    let quickPrompts = [
        "I feel anxious",
        "I feel lonely",
        "I'm overwhelmed",
        "I can't sleep",
        "I need motivation"
    ]
    
    init(chatService: ChatService) {
        self.chatService = chatService
    }
    
    func sendQuickPrompt(_ prompt: String) {
        input = prompt
        Task {
            await sendMessage()
        }
    }
    
    func sendMessage() async {
        let text = input.trimmed
        guard !text.isEmpty, !isResponding else { return }

        input = ""
        isResponding = true

        messages.append(ChatMessage(role: .user, text: text))
        messages.append(ChatMessage(role: .assistant, text: "Thinking with you..."))

        let assistantIndex = messages.count - 1
        var didReceiveFirstChunk = false

        do {
            for try await chunk in chatService.sendMessageStream(text) {
                if !didReceiveFirstChunk {
                    messages[assistantIndex].text = ""
                    didReceiveFirstChunk = true
                }

                messages[assistantIndex].text += chunk
            }
        } catch {
            messages[assistantIndex].text = "Something went wrong. Please try again."
            errorMessage = error.localizedDescription
        }

        isResponding = false
    }
}
