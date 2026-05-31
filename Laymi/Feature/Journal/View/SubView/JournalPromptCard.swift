//
//  JournalPromptCard.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct JournalPromptCard: View {
    let prompt: JournalPrompt
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Text(prompt.rawValue)
                    .font(.headline)
                    .foregroundStyle(Color(.label))
                
                Text(prompt.subtitle)
                    .font(.caption)
                    .foregroundStyle(Color(.systemGray))
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 105, alignment: .topLeading)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.tertiarySystemBackground))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.brightOrange.opacity(0.38), lineWidth: 1.2)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    JournalPromptCard(prompt: .anxietyUnpack, action: {})
        .padding()
        .background(Color(.secondarySystemBackground))
}
