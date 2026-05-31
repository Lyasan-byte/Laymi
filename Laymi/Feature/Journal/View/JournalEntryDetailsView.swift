//
//  JournalEntryDetailsView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct JournalEntryDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    
    let entry: JournalEntry
    let onDelete: () -> ()
    
    @State private var isDeleteConfirmationPresented = false
    
    var body: some View {
        ZStack {
            TopGradientBackground(accentColor: .backOrange)
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    title
                    questions
                    text
                }
                .padding()
            }
        }
        .navigationTitle("Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                deleteButton
            }
        }
    }
    
    private var title: some View {
        VStack(alignment: .leading, spacing: 8) {
            LargeTitle(text: entry.title)
            
            HStack {
                Text(entry.mood.rawValue)
                Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
            }
            .font(.subheadline)
            .foregroundStyle(Color(.systemGray))
        }
    }
    
    private var questions: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(entry.prompt.questions, id: \.self) { question in
                Text(question)
                    .font(.caption)
                    .foregroundStyle(Color(.systemGray))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.tertiarySystemBackground))
        }
    }
    
    private var text: some View {
        Text(entry.text)
            .foregroundStyle(Color(.label))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.tertiarySystemBackground))
            }
    }
    
    private var deleteButton: some View {
        Button {
            isDeleteConfirmationPresented = true
        } label: {
            Image(systemName: "trash")
        }
        .tint(.red)
        .confirmationDialog("Delete this entry?", isPresented: $isDeleteConfirmationPresented, titleVisibility: .visible) {
            Button("Delete Entry", role: .destructive) {
                onDelete()
                dismiss()
            }
        }
    }
}

#Preview {
    JournalEntryDetailsView(entry: JournalEntry(prompt: .tinyWin, text: "I finished one small task today.", mood: .happy), onDelete: {})
}
