//
//  ExerciseViewModel.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

@MainActor
@Observable
final class ExerciseViewModel {
    private let totalDuration = 180
    
    private var timerTask: Task<Void, Never>?
    private var phaseIndex = 0
    private var phaseElapsedSeconds = 0
    
    var remainingSeconds = 180
    var currentPhase: BreathingPhase = .inhale
    var isRunning = false
    var isFinished = false
    
    var formattedRemainingTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var phaseRemainingSeconds: Int {
        max(currentPhase.duration - phaseElapsedSeconds, 0)
    }
    
    var progress: Double {
        1 - (Double(remainingSeconds) / Double(totalDuration))
    }
    
    var primaryButtonTitle: String {
        if isFinished {
            return "Start Again"
        }
        
        return isRunning ? "Pause" : "Start"
    }
    
    func toggleSession() {
        if isFinished {
            reset()
        }
        
        isRunning ? pause() : start()
    }
    
    func reset() {
        timerTask?.cancel()
        timerTask = nil
        phaseIndex = 0
        phaseElapsedSeconds = 0
        remainingSeconds = totalDuration
        currentPhase = .inhale
        isRunning = false
        isFinished = false
    }
    
    private func start() {
        isRunning = true
        isFinished = false
        timerTask?.cancel()
        
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                guard let self else { return }
                tick()
            }
        }
    }
    
    func pause() {
        timerTask?.cancel()
        timerTask = nil
        isRunning = false
    }
    
    private func tick() {
        guard remainingSeconds > 0 else {
            finish()
            return
        }
        
        remainingSeconds -= 1
        phaseElapsedSeconds += 1
        
        if phaseElapsedSeconds >= currentPhase.duration {
            moveToNextPhase()
        }
        
        if remainingSeconds == 0 {
            finish()
        }
    }
    
    private func moveToNextPhase() {
        phaseIndex = (phaseIndex + 1) % BreathingPhase.allCases.count
        currentPhase = BreathingPhase.allCases[phaseIndex]
        phaseElapsedSeconds = 0
    }
    
    private func finish() {
        timerTask?.cancel()
        timerTask = nil
        isRunning = false
        isFinished = true
        remainingSeconds = 0
    }
}
