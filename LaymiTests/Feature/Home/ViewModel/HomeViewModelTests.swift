//
//  HomeViewModelTests.swift
//  LaymiTests
//
//  Created by Ляйсан
//

import Foundation
import Testing
@testable import Laymi

@MainActor
struct HomeViewModelTests {
    @Test func loadHomeContentUsesCachedQuoteOfTheDay() async {
        let cachedQuote = Quote(text: "Cached daily quote", author: "Laymi")
        let quoteService = MockQuoteService(result: .success([Quote(text: "Remote", author: "API")]))
        let quoteStorage = MockQuoteStorage(quoteOfTheDay: cachedQuote)
        let healthService = MockHealthService()
        let viewModel = HomeViewModel(
            healthService: healthService,
            quoteService: quoteService,
            quoteStorage: quoteStorage
        )
        
        UserDefaults.standard.removeObject(forKey: "hasRequestedHealthAccess")
        await viewModel.loadHomeContent()
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.quoteOfTheDay == cachedQuote)
        #expect(quoteService.requestedURLs.isEmpty)
    }
    
    @Test func loadHomeContentFetchesAndSavesQuoteOfTheDayWhenCacheIsEmpty() async {
        let remoteQuote = Quote(text: "Remote daily quote", author: "API")
        let quoteService = MockQuoteService(result: .success([remoteQuote]))
        let quoteStorage = MockQuoteStorage()
        let healthService = MockHealthService()
        let viewModel = HomeViewModel(
            healthService: healthService,
            quoteService: quoteService,
            quoteStorage: quoteStorage
        )
        
        UserDefaults.standard.removeObject(forKey: "hasRequestedHealthAccess")
        await viewModel.loadHomeContent()
        
        #expect(viewModel.quoteOfTheDay == remoteQuote)
        #expect(await quoteStorage.savedQuoteOfTheDay == remoteQuote)
    }
    
    @Test func requestAuthorizationLoadsHealthData() async {
        let viewModel = HomeViewModel(
            healthService: MockHealthService(
                stepsResult: .success(4_200),
                heartRateResult: .success(72)
            ),
            quoteService: MockQuoteService(result: .success([])),
            quoteStorage: MockQuoteStorage()
        )
        
        await viewModel.requestAuthorization()
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.isHealthConnected)
        #expect(viewModel.todaysSteps == 4_200)
        #expect(viewModel.recentHeartRate == 72)
    }
    
    @Test func requestAuthorizationShowsErrorWhenAuthorizationFails() async {
        let viewModel = HomeViewModel(
            healthService: MockHealthService(requestAuthorizationError: TestError.expected),
            quoteService: MockQuoteService(result: .success([])),
            quoteStorage: MockQuoteStorage()
        )
        
        await viewModel.requestAuthorization()
        
        #expect(viewModel.isHealthConnected == false)
        #expect(viewModel.errorMessage == "Test error")
    }
}
