//
//  ArticleViewControllerRepresentable.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI
import UIKit

struct ArticleViewControllerRepresentable: UIViewControllerRepresentable {
    let article: Article
    
    func makeUIViewController(context: Context) -> ArticleViewController {
        ArticleViewController(article: article)
    }
    
    func updateUIViewController(_ uiViewController: ArticleViewController, context: Context) { }
}
