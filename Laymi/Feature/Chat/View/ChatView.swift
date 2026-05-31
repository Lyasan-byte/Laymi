//
//  ChatView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct ChatView: View {
    @Bindable private var chatViewModel: ChatViewModel
    
    @FocusState private var isFocused: Bool
    
    init(chatViewModel: ChatViewModel) {
        self.chatViewModel = chatViewModel
    }
    
    var body: some View {
        ZStack {
            background
            VStack(spacing: 18) {
                header
                quickPrompts
                messages
                //inputBar
            }
            .padding()
            .padding(.top, 20)
        }
        .hideKeyboardOnTap()
    }
    
    @ViewBuilder private var background: some View {
        Color(.secondarySystemBackground).ignoresSafeArea()
        BackgroundCircle(color: .backPurple)
    }
    
    private var header: some View {
        VStack(spacing: 4) {
            LargeTitle(text: "Laymi")
            Subtitle(text: "A safe space to say what you feel")
        }
    }
    
    private var quickPrompts: some View {
        FlowLayout(spacing: 8) {
            ForEach(chatViewModel.quickPrompts, id: \.self) { prompt in
                Button {
                    chatViewModel.sendQuickPrompt(prompt)
                } label: {
                    Text(prompt)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.brightPurple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 9)
                        .background {
                            Capsule()
                                .fill(Color(.tertiarySystemBackground))
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var messages: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(chatViewModel.messages) { message in
                        ChatBubble(message: message)
                            .id(message.id)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                inputBar
            }
            .onChange(of: chatViewModel.messages.count) {
                scrollToBottom(proxy)
            }
            .onChange(of: chatViewModel.messages.last?.text) {
                scrollToBottom(proxy)
            }
            .onChange(of: isFocused) {
                if isFocused {
                    scrollToBottom(proxy)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Message Laymi", text: $chatViewModel.input, axis: .vertical)
                .lineLimit(1...4)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background {
                    Capsule()
                        .fill(Color(.tertiarySystemBackground))
                }
                .focused($isFocused)
            Button {
                isFocused = false
                Task {
                    await chatViewModel.sendMessage()
                }
            } label: {
                Image(systemName: "arrow.up")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background {
                        Circle()
                            .fill(chatViewModel.input.trimmed.isEmpty ? Color.backPurple : Color.brightPurple)
                    }
            }
            .disabled(chatViewModel.input.trimmed.isEmpty ||
                      chatViewModel.isResponding)
        }
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let lastMessage = chatViewModel.messages.last else { return }
        withAnimation(.easeOut(duration: 0.25)) {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

#Preview {
    ChatView(chatViewModel: ChatViewModel(chatService: MockChatService()))
}
