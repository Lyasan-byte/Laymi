//
//  BreathingPhase.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

enum BreathingPhase: String, CaseIterable {
    case inhale = "Inhale"
    case hold = "Hold"
    case exhale = "Exhale"
    
    var duration: Int {
        switch self {
        case .inhale:
            return 4
        case .hold:
            return 4
        case .exhale:
            return 6
        }
    }
    
    var instruction: String {
        switch self {
        case .inhale:
            return "Slowly breathe in"
        case .hold:
            return "Stay with the pause"
        case .exhale:
            return "Let the breath go"
        }
    }
    
    var scale: Double {
        switch self {
        case .inhale:
            return 1.12
        case .hold:
            return 1.12
        case .exhale:
            return 0.78
        }
    }
}
