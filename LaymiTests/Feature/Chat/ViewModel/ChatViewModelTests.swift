//
//  ChatViewModelTests.swift
//  LaymiTests
//
//  Created by Ляйсан
//

import Testing
@testable import Laymi

@MainActor
struct ChatViewModelTests {
    @Test func sendMessageAddsUserMessageAndStreamsAssistantResponse() async {
        let service = MockChatService(chunks: ["I hear ", "you."])
        let viewModel = ChatViewModel(chatService: service)
        viewModel.input = "I feel anxious"
        
        await viewModel.sendMessage()
        
        #expect(viewModel.input.isEmpty)
        #expect(viewModel.isResponding == false)
        #expect(viewModel.messages[1].role == .user)
        #expect(viewModel.messages[1].text == "I feel anxious")
        #expect(viewModel.messages[2].role == .assistant)
        #expect(viewModel.messages[2].text == "I hear you.")
    }
    
    @Test func sendMessageIgnoresEmptyInput() async {
        let service = MockChatService(chunks: ["Hello"])
        let viewModel = ChatViewModel(chatService: service)
        viewModel.input = "   "
        
        await viewModel.sendMessage()
        
        #expect(viewModel.messages.count == 1)
    }
    
    @Test func sendMessageShowsErrorMessageWhenServiceFails() async {
        let service = MockChatService(error: TestError.expected)
        let viewModel = ChatViewModel(chatService: service)
        viewModel.input = "Help"
        
        await viewModel.sendMessage()
        
        #expect(viewModel.errorMessage == "Test error")
        #expect(viewModel.messages.last?.text == "Something went wrong. Please try again.")
        #expect(viewModel.isResponding == false)
    }
}
