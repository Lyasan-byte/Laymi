//
//  GenderSheet.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct GenderSheet: View {
    @Binding var gender: Gender
    let action: () -> ()
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $gender) {
                    ForEach(Gender.allCases) { gender in
                        Text(gender.rawValue)
                    }
                }
                .pickerStyle(.segmented)

                Spacer()
            }
            .padding()
            .navigationTitle("Gender")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    CheckmarkButton(color: .brightPurple) {
                        action()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var gender = Gender.male
    GenderSheet(gender: $gender, action: {})
}
