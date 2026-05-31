//
//  QuoteCardView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct QuoteCardView: View {
    let quote: Quote
    
    var body: some View {
        VStack {
            Spacer()
            Text(quote.text)
                .font(.title3)
                .offset(y: 20)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
            Spacer()
            Text(quote.author)
                .padding(.bottom, 20)
                .italic()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    QuoteCardView(quote: Quote(text: "Your time is limited, so don't waste it living someone else's life", author: "Steve Jobs"))
}
