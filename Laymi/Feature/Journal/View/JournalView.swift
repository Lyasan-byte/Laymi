//
//  JournalView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct JournalView: View {
    @State private var journalViewModel: JournalViewModel
    
    init(journalViewModel: JournalViewModel) {
        self._journalViewModel = State(initialValue: journalViewModel)
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        header
                        prompts
                        recentEntries
                    }
                    .padding()
                    .padding(.top, 20)
                }
                .scrollIndicators(.hidden)
            }
            .sheet(item: $journalViewModel.activeSheet) { sheet in
                switch sheet {
                case .create(let prompt):
                    CreateJournalEntryView(prompt: prompt) { text, mood in
                        Task {
                            await journalViewModel.createEntry(prompt: prompt, text: text, mood: mood)
                        }
                    }
                }
            }
            .task {
                await journalViewModel.loadEntries()
            }
            .alert("Something went wrong", isPresented: journalErrorPresented) {
                Button("OK") {
                    journalViewModel.clearError()
                }
            } message: {
                Text(journalViewModel.errorMessage)
            }
        }
    }
    
    @ViewBuilder private var background: some View {
        Color(.secondarySystemBackground).ignoresSafeArea()
        BackgroundCircle(color: .backOrange.opacity(0.85))
    }
    
    private var header: some View {
        VStack(spacing: 4) {
            LargeTitle(text: "Journal")
            Subtitle(text: "Understand your thoughts gently")
        }
    }
    
    private var prompts: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Start guided reflection")
                .font(.headline)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(journalViewModel.prompts) { prompt in
                    JournalPromptCard(prompt: prompt) {
                        journalViewModel.openCreateSheet(for: prompt)
                    }
                }
            }
        }
    }
    
    @ViewBuilder private var recentEntries: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Entries")
                .font(.headline)
            
            switch journalViewModel.viewState {
            case .loading:
                LottieAnimationView(fileName: "Loading")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            case .empty:
                emptyState
            case .content:
                ForEach(journalViewModel.entries) { entry in
                    NavigationLink {
                        JournalEntryDetailsView(entry: entry) {
                            Task {
                                await journalViewModel.deleteEntry(entry)
                            }
                        }
                    } label: {
                        JournalEntryCard(entry: entry)
                    }
                }
            case .error:
                emptyState
            }
        }
    }
    
    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("No entries yet")
                .font(.headline)
            
            Text("Choose one reflection above when you want to write something down.")
                .foregroundStyle(Color(.systemGray))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.tertiarySystemBackground))
        }
    }
    
    private var journalErrorPresented: Binding<Bool> {
        Binding {
            journalViewModel.isErrorPresented
        } set: { isPresented in
            if !isPresented {
                journalViewModel.clearError()
            }
        }
    }
}

#Preview {
    JournalView(journalViewModel: JournalViewModel(journalStorage: MockJournalStorage()))
}
