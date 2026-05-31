//
//  ChatBubble.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage
    
    private var isUser: Bool {
        message.role == .user
    }
    
    var body: some View {
        VStack(alignment: isUser ? .trailing : .leading, spacing: 10) {
            Text(message.text)
                .foregroundStyle(isUser ? .white : Color(.label))
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(isUser ? Color.brightPurple : Color(.tertiarySystemBackground))
                }
        }
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
        .padding(.vertical, 3)
    }
}

#Preview {
    ChatBubble(
        message: ChatMessage(
            role: .assistant,
            text: "Would one small calming step help?"
        )
    )
}
