//
//  HealthCellRepresentable.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import SwiftUI

struct HealthCellRepresentable: UIViewRepresentable {
    let title: String
    let textColor: UIColor
    let value: Double?
    let unit: String
    
    
    func makeUIView(context: Context) -> HealthCellView {
        HealthCellView()
    }
    
    func updateUIView(_ uiView: HealthCellView, context: Context) {
        uiView.configure(title: title, textColor: textColor, value: value, unit: unit)
    }
}
