//
//  GoogleButton.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct GoogleButton: View {
    var action: () -> ()
    
    var body: some View {
        PrimaryButton(textColor: Color(.label), backgroundColor: Color(.quaternarySystemFill)) {
            HStack {
                Image("googleIcon")
                    .resizable()
                    .frame(width: 25, height: 25)
                Text("Continue With Google")
            }
        } action: { action() }
    }
}

#Preview {
    GoogleButton(action: {})
}
