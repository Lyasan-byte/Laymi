//
//  CreateJournalEntryView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct CreateJournalEntryView: View {
    @Environment(\.dismiss) private var dismiss
    
    let prompt: JournalPrompt
    let onSave: (String, JournalMood) -> ()
    
    @State private var text = ""
    @State private var mood: JournalMood = .calm
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.secondarySystemBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        title
                        questions
                        moodPicker
                        editor
                    }
                    .padding()
                }
            }
            .hideKeyboardOnTap()
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    CheckmarkButton(color: .brightPurple) {
                        onSave(text, mood)
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private var title: some View {
        VStack(alignment: .leading, spacing: 6) {
            LargeTitle(text: prompt.rawValue)
            Subtitle(text: prompt.subtitle)
        }
    }
    
    private var questions: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(prompt.questions, id: \.self) { question in
                Text(question)
                    .font(.subheadline)
                    .foregroundStyle(Color(.label))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(.tertiarySystemBackground))
                    }
            }
        }
    }
    
    private var moodPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mood")
                .font(.headline)
            
            Picker("Mood", selection: $mood) {
                ForEach(JournalMood.allCases) { mood in
                    Text(mood.rawValue).tag(mood)
                }
            }
            .pickerStyle(.menu)
            .tint(.brightPurple)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.tertiarySystemBackground))
            }
        }
    }
    
    private var editor: some View {
        TextEditor(text: $text)
            .frame(minHeight: 220)
            .padding(12)
            .scrollContentBackground(.hidden)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.tertiarySystemBackground))
            }
    }
}

#Preview {
    CreateJournalEntryView(prompt: .anxietyUnpack, onSave: { _, _ in })
}
