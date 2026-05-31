//
//  LinearGradientBackground.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct TopGradientBackground: View {
    let accentColor: Color
    
    private let backgroundColor = Color(.secondarySystemBackground)
    
    var body: some View {
        LinearGradient(
            colors: [
                accentColor,
                backgroundColor,
                backgroundColor,
                backgroundColor,
                backgroundColor
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview {
    TopGradientBackground(accentColor: .orange)
}
