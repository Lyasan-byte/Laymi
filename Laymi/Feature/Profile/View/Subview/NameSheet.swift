//
//  NameSheet.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import SwiftUI

struct NameSheet: View {
    @Binding var name: String
    let action: () -> ()
    
    var body: some View {
        NavigationStack {
            VStack {
                FormField(title: "NAME", placeholder: "Laysan", input: $name)
                Spacer()
            }
            .hideKeyboardOnTap()
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    CheckmarkButton(color: name.trimmed.isEmpty ? .gray : .brightPurple) {
                        action()
                    }
                    .disabled(name.trimmed.isEmpty)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var name = ""
    NameSheet(name: $name, action: {})
}
