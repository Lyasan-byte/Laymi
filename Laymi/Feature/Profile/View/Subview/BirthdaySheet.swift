//
//  BirthdaySheet.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import SwiftUI

struct BirthdaySheet: View {
    @Binding var date: Date
    let action: () -> ()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.secondarySystemBackground).ignoresSafeArea()
                VStack {
                    datePicker
                    Spacer()
                }
                .padding()
                .navigationTitle("Birthday")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        DismissButton()
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        CheckmarkButton(color: .brightPurple) {
                            action()
                        }
                        .disabled(date > Date())
                    }
                }
            }
        }
    }
    
    private var datePicker: some View {
        DatePicker(
            "Birthday",
            selection: $date,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(.tertiarySystemBackground))
        }
    }
}

#Preview {
    @Previewable @State var date = Date()
    BirthdaySheet(date: $date, action: {})
}
