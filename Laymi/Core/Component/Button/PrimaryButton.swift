//
//  PrimaryButton.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct PrimaryButton<Content: View>: View {
    var textColor: Color = .white
    var backgroundColor: Color
    var content: () -> Content
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            content()
                .foregroundStyle(textColor)
                .fontWeight(.medium)
                .font(.system(size: 18))
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(backgroundColor)
                }
        }
    }
}
