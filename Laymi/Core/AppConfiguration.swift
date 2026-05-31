//
//  AppConfiguration.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

enum AppConfiguration {
    static let quoteOfTheDayURL = value(for: "API_NINJAS_QUOTE_OF_THE_DAY_URL")
    static let quotesURL = value(for: "API_NINJAS_QUOTES_URL")
    
    private static func value(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              !value.isEmpty else {
            fatalError("\(key) is missing. Add it to Secrets.xcconfig.")
        }
        
        return value
    }
}
