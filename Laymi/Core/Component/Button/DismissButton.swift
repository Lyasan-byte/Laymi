//
//  DismissButton.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
        }
    }
}

#Preview {
    DismissButton()
}
