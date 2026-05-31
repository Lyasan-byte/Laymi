//
//  HealthRequestButton.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct HealthRequestButton: View {
    let action: () -> ()
    
    var body: some View {
        BackgroundLayer(height: 120)
            .overlay {
                VStack(spacing: 10) {
                    button
                    subtitle
                }
            }
    }
    
    private var button: some View {
        Button {
            action()
        } label: {
            Text("Connect Health")
        }
        .buttonStyle(.glassProminent)
        .tint(.green)
    }
    
    private var subtitle: some View {
        Text("Connect Health to see gentle insights from your steps, sleep, and heart rate.")
            .font(.caption)
            .foregroundStyle(Color(.secondaryLabel))
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}

#Preview {
    HealthRequestButton(action: {})
}
