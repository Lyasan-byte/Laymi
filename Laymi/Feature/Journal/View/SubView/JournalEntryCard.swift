//
//  JournalEntryCard.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct JournalEntryCard: View {
    let entry: JournalEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                title
                Spacer()
                mood
            }
            text
            date
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.tertiarySystemBackground))
        }
    }
    
    private var title: some View {
        Text(entry.title)
            .font(.headline)
            .foregroundStyle(Color(.label))
    }
    
    private var mood: some View {
        Text(entry.mood.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(.brightPurple)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background {
                Capsule()
                    .fill(Color.brightPurple.opacity(0.25))
            }
    }
    
    private var text: some View {
        Text(entry.preview)
            .font(.subheadline)
            .foregroundStyle(Color(.systemGray))
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var date: some View {
        Text(entry.createdAt.formatted(date: .abbreviated, time: .omitted))
            .font(.caption)
            .foregroundStyle(Color(.secondaryLabel))
    }
}

#Preview {
    JournalEntryCard(entry: JournalEntry(prompt: .tinyWin, text: "I finished one task today.", mood: .calm))
        .padding()
        .background(Color(.secondarySystemBackground))
}
