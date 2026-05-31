//
//  ArticleView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct ArticleView: View {
    let article: Article
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Image(article.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                    LargeTitle(text: article.title)
                        .padding()
                    articleText
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissButton()
                }
            }
        }
    }
    
    private var articleText: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(article.description.components(separatedBy: "\n"), id: \.self) { line in
                if line.hasPrefix("## ") {
                    Text(line.replacingOccurrences(of: "## ", with: ""))
                        .font(.title3)
                        .fontWeight(.bold)
                } else if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    EmptyView()
                } else {
                    Text(line)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ArticleView(article: Article.stepsArticle)
}
