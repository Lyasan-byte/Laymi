//
//  QuoteOfTheDayCard.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct QuoteOfTheDayCard: View {
    let quote: Quote
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: "quote.bubble")
                .font(.title)
                .foregroundStyle(.mint)
            VStack(spacing: 16) {
                Text(quote.text)
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(quote.author)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(.tertiarySystemBackground))
        }
    }
}

#Preview {
    QuoteOfTheDayCard(quote: .init(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", author: "Lorem Ipsum"))
}
