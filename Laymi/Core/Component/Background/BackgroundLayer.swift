//
//  BackgroundLayer.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct BackgroundLayer: View {
    let height: Double
    let color: Color
    
    init(height: Double, color: Color = Color(.tertiarySystemBackground)) {
        self.height = height
        self.color = color
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(color)
            .frame(maxWidth: .infinity)
            .frame(height: height)
    }
}

#Preview {
    BackgroundLayer(height: 120)
}
