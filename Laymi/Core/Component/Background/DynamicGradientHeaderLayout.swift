//
//  DynamicGradientHeaderLayout.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct DynamicGradientHeaderLayout: View {
    @State private var isAnimated = false
    var colors: [Color]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(AngularGradient(colors: colors, center: .center, angle: .degrees(isAnimated ? 270 : 0)))
                .frame(height: 200)
                .blur(radius: 20)
                .onAppear {
                    withAnimation(Animation.linear(duration: 40).repeatForever(autoreverses: false)) {
                        isAnimated = true
                    }
                }
                .onDisappear { isAnimated = false }
                .ignoresSafeArea()
    }
}

#Preview {
    DynamicGradientHeaderLayout(colors: [.orange, .purple])
}
