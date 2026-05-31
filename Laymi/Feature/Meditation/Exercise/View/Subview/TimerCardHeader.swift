//
//  TimerCardHeader.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct TimerCardHeader: View {
    var body: some View {
        VStack(spacing: 6) {
            Text("Breathing Space")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color(.label))
            
            Text("Follow the rhythm and let your mind settle.")
                .font(.subheadline)
                .foregroundStyle(Color(.systemGray))
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    TimerCardHeader()
}
