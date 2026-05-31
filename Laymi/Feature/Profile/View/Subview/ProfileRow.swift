//
//  ProfileRow.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct ProfileRow: View {
    let name: String
    let value: String?
    let divider: Bool
    let action: () -> ()
    
    init(name: String, value: String?, divider: Bool = true, action: @escaping () -> () = {}) {
        self.name = name
        self.value = value
        self.divider = divider
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(name)
                Spacer()
                Text(value ?? "Not Set")
                    .foregroundStyle(Color(.secondaryLabel))
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(.secondaryLabel))
                    .fontWeight(.semibold)
                    .font(.caption)
            }
            .font(.system(size: 18))
        }
        .buttonStyle(.plain)
        
        if divider {
            DividerView(height: 0.2)
                .padding(.vertical, 8)
        }
    }
}

#Preview {
    ProfileRow(name: "Name", value: "Laysan")
}
