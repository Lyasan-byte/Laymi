//
//  ExerciseView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct ExerciseView: View {
    @Bindable private var exerciseViewModel: ExerciseViewModel
    
    init(exerciseViewModel: ExerciseViewModel) {
        self.exerciseViewModel = exerciseViewModel
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color(.tertiarySystemBackground))
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height - 15
                    )
                    .overlay {
                        exerciseCard
                    }
            }
            .frame(
                width: proxy.size.width,
                height: proxy.size.height,
                alignment: .center
            )
        }
    }
    
    private var exerciseCard: some View {
        VStack(spacing: 18) {
            TimerCardHeader()
            breathingCircle
            timer
            controls
        }
        .padding(16)
        .frame(maxWidth: .infinity)
    }
    
    private var breathingCircle: some View {
        ZStack {
            TimerCircle(progress: exerciseViewModel.progress, scale: exerciseViewModel.currentPhase.scale)
            BreathingResult(
                isFinished: exerciseViewModel.isFinished,
                phase: exerciseViewModel.currentPhase.rawValue,
                remainingSeconds: exerciseViewModel.phaseRemainingSeconds
            )
        }
        .frame(height: 250)
        .animation(.easeInOut(duration: 1.1), value: exerciseViewModel.currentPhase)
        .animation(.easeInOut(duration: 0.35), value: exerciseViewModel.progress)
    }
    
    private var timer: some View {
        VStack(spacing: 8) {
            Text(exerciseViewModel.isFinished ? "Your breathing practice is complete." : exerciseViewModel.currentPhase.instruction)
                .font(.headline)
                .foregroundStyle(Color(.label))
                .multilineTextAlignment(.center)
            
            Text(exerciseViewModel.formattedRemainingTime)
                .font(.system(size: 40, weight: .semibold, design: .rounded))
                .foregroundStyle(.brightPink)
                .monospacedDigit()
        }
    }
    
    private var controls: some View {
        HStack(spacing: 12) {
            startAndStopButtons
            resetButton   
        }
        .buttonStyle(.glassProminent)
    }
    
    private var startAndStopButtons: some View {
        Button {
            exerciseViewModel.toggleSession()
        } label: {
            Label(
                exerciseViewModel.primaryButtonTitle,
                systemImage: exerciseViewModel.isRunning ? "pause.fill" : "play.fill"
            )
            .font(.headline)
            .foregroundStyle(Color(.systemBackground))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
        .tint(.brightPink)
    }
    
    private var resetButton: some View {
        Button {
            exerciseViewModel.reset()
        } label: {
            Image(systemName: "arrow.counterclockwise")
                .font(.headline)
                .foregroundStyle(.brightPink)
                .frame(width: 42, height: 42)
        }
        .tint(Color.pinkGrad.opacity(0.2))
        .clipShape(.circle)
    }
}

#Preview {
    ExerciseView(exerciseViewModel: ExerciseViewModel())
}
