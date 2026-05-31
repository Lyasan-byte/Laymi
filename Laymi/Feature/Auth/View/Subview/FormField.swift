//
//  FormField.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct FormField: View {
    var title: String
    var placeholder: String
    var isSecure = false
    @Binding var input: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(.textGray)
                .fontWeight(.semibold)
            
            if isSecure {
                SecureField(placeholder, text: $input)
                    .padding()
                    .background(Color(.quaternarySystemFill))
                    .clipShape(.capsule)
            } else {
                TextField(placeholder, text: $input)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color(.quaternarySystemFill))
                    .clipShape(.capsule)
            }
        }
    }
}

#Preview {
    @Previewable @State var input = ""
    FormField(title: "EMAIL", placeholder: "hello", input: $input)
}
