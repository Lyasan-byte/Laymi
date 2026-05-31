//
//  JournalPromptFilteringTests.swift
//  LaymiTests
//
//  Created by Ляйсан
//

import Foundation
import Testing
@testable import Laymi

struct JournalPromptFilteringTests {
    @Test func promptsCanBeFilteredBySearchText() {
        let searchText = "gratitude"
        
        let filteredPrompts = JournalPrompt.allCases.filter {
            $0.rawValue.localizedCaseInsensitiveContains(searchText)
        }
        
        #expect(filteredPrompts == [.gratitudeNote])
    }
}
