//
//  TimerCircle.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct TimerCircle: View {
    let progress: Double
    let scale: Double
    
    var body: some View {
        ZStack {
            shadow
            placeholderLayer
            progressLayer
            infoCircle
        }
    }
    
    private var shadow: some View {
        Circle()
            .fill(Color.brightPink.opacity(0.14))
            .frame(width: 230, height: 230)
            .blur(radius: 18)
            .scaleEffect(scale)
    }
    
    private var placeholderLayer: some View {
        Circle()
            .stroke(Color.pinkGrad.opacity(0.18), lineWidth: 20)
            .frame(width: 210, height: 210)
    }
    
    
    private var progressLayer: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: Color.colorsForProgressRing),
                    center: .center
                ),
                style: StrokeStyle(
                    lineWidth: 20,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .rotationEffect(.degrees(-90))
            .frame(width: 210, height: 210)
    }
    
    private var infoCircle: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [.pinkGrad.opacity(0.9), .backPurple.opacity(0.74)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 142, height: 142)
            .shadow(color: .pinkGrad.opacity(0.35), radius: 24, y: 12)
            .scaleEffect(scale)
    }
}

#Preview {
    TimerCircle(progress: 0.3, scale: 0.5)
}
