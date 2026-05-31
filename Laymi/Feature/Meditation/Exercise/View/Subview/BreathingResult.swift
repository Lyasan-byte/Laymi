//
//  BreathingResult.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct BreathingResult: View {
    let isFinished: Bool
    let phase: String
    let remainingSeconds: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: isFinished ? "checkmark" : "wind")
                .font(.title2)
                .foregroundStyle(.white.opacity(0.92))
            
            Text(isFinished ? "Done" : phase)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            
            Text(isFinished ? "Well done" : "\(remainingSeconds)s")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.82))
        }
    }
}

#Preview {
    BreathingResult(isFinished: false, phase: "Inhale", remainingSeconds: 40)
}
