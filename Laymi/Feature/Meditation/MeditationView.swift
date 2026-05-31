//
//  MeditationView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

enum MeditationType: String, Identifiable, CaseIterable {
    case exercise
    case reflect
    
    var id: Self { self }
}

struct MeditationView: View {
    @Bindable private var exerciseViewModel: ExerciseViewModel
    @Bindable private var quotesViewModel: QuotesViewModel
    
    @State private var selectedType: MeditationType = .exercise
    
    init(exerciseViewModel: ExerciseViewModel, quotesViewModel: QuotesViewModel) {
        self.exerciseViewModel = exerciseViewModel
        self.quotesViewModel = quotesViewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            TopGradientBackground(accentColor: .pinkGrad)
            VStack {
                title
                picker
                content.frame(maxHeight: .infinity)
            }
            .padding()
            .padding(.top, 25)
        }
    }
    
    @ViewBuilder private var title: some View {
        LargeTitle(text: "Mindful Pause")
        Subtitle(text: "Breathe, read, and relax")
    }
    
    private var picker: some View {
        Picker("", selection: $selectedType) {
            ForEach(MeditationType.allCases) { type in
                Text(type.rawValue.capitalized)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding(.top, 8)
    }
    
    @ViewBuilder private var content: some View {
        switch selectedType {
        case .exercise:
            ExerciseView(exerciseViewModel: exerciseViewModel)
                .padding(.top, 8)
        case .reflect:
            QuotesView(quotesViewModel: quotesViewModel)
                .padding(.top, 8)
        }
    }
}

#Preview {
    MeditationView(exerciseViewModel: ExerciseViewModel(), quotesViewModel: QuotesViewModel(quoteService: RemoteQuoteService(), quoteStorage: MockQuoteStorage()))
}
