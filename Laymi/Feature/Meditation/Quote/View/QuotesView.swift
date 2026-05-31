//
//  QuotesView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct QuotesView: View {
    @Bindable private var quotesViewModel: QuotesViewModel
    
    init(quotesViewModel: QuotesViewModel) {
        self.quotesViewModel = quotesViewModel
    }
    
    var body: some View {
        Group {
            switch quotesViewModel.state {
            case .loading:
                LottieAnimationView(fileName: "Loading")
            case .empty:
                ContentUnavailableView("No quotes yet", systemImage: "quote.bubble", description: Text("A little support will appear here soon."))
            case .content:
                quotes
            case .error(_):
                Color.clear
            }
        }
        .task {
            await quotesViewModel.fetchQuotes()
        }
        .alert("Something went wrong", isPresented: errorPresented) {
            Button("OK") {
                quotesViewModel.clearError()
            }
        } message: {
            Text(quotesViewModel.errorMessage ?? "")
        }
    }
    
    private var quotes: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(quotesViewModel.quotes) { quote in
                        ZStack {
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color(.tertiarySystemBackground))
                                .frame(
                                    width: proxy.size.width,
                                    height: proxy.size.height - 15
                                )
                                .overlay {
                                    QuoteCardView(quote: quote)
                                }
                        }
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height,
                            alignment: .center
                        )
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
        }
    }
    
    private var errorPresented: Binding<Bool> {
        Binding {
            quotesViewModel.errorPresented
        } set: { isPresented in
            if !isPresented {
                quotesViewModel.clearError()
            }
        }
    }
}

#Preview {
    QuotesView(
        quotesViewModel: QuotesViewModel(
            quoteService: RemoteQuoteService(),
            quoteStorage: MockQuoteStorage()
        )
    )
}
