//
//  DividerView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct DividerView: View {
    let height: Double
    
    init(height: Double = 0.5) {
        self.height = height
    }
    
    var body: some View {
        Rectangle()
            .foregroundStyle(Color(.secondaryLabel))
            .frame(height: height)
    }
}

#Preview {
    DividerView()
}
