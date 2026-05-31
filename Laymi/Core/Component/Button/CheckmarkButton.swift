//
//  CheckmarkButton.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct CheckmarkButton: View {
    @Environment(\.dismiss) private var dismiss
    
    let color: Color
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
            dismiss()
        } label: {
            Image(systemName: "checkmark")
        }
        .buttonStyle(.glassProminent)
        .tint(color)
    }
}

#Preview {
    CheckmarkButton(color: .purple, action: {})
}
