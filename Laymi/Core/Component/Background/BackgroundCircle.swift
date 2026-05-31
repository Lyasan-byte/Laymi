//
//  BackgroundCircle.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct BackgroundCircle: View {
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 150, height: 150)
            .blur(radius: 90)
    }
}

#Preview {
    BackgroundCircle(color: .orange)
}
