//
//  Color.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import SwiftUI

extension Color {
    static let colorsForQuotesGradientBackground: [Color] = [
        .backPurple,
        .backPurple.opacity(0.7),
        .pinkGrad.opacity(0.7),
        .backOrange,
        .pinkGrad.opacity(0.8)
    ]
    
    static let colorsForProgressRing: [Color] = [.backPurple,
                                        .backPurple.opacity(0.7),
                                        .pinkGrad.opacity(0.7),
                                        .backOrange.opacity(0.7),
                                        .pinkGrad.opacity(0.8),
                                        .backPurple.opacity(0.7),
                                        .backPurple]
}
