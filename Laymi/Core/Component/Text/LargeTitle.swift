//
//  LargeTitle.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct LargeTitle: View {
    var text: String
    var alignment: Alignment = .leading
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .foregroundStyle(Color(.label))
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

#Preview {
    LargeTitle(text: "Chat")
}
