//
//  TestError.swift
//  LaymiTests
//
//  Created by Ляйсан
//

import Foundation

enum TestError: LocalizedError {
    case expected
    
    var errorDescription: String? {
        "Test error"
    }
}
