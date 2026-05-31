//
//  Subtitle.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import SwiftUI

struct Subtitle: View {
    var text: String
    var color: Color = Color(.systemGray)
    var alignment: Alignment = .leading
    
    var body: some View {
        Text(text)
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}
