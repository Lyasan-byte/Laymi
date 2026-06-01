//
//  HomeViewModel.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

@MainActor
@Observable
final class HomeViewModel {
    private let healthService: HealthService
    private let quoteService: QuoteService
    private let quoteStorage: QuoteStorage
    
    var isLoading = true
    var healthState: HealthViewState = .needsAuthorization
    var quoteOfTheDay: Quote?
    var todaysSteps: Double?
    var recentHeartRate: Double?
    var errorMessage: String?
    
    private let quoteURL = AppConfiguration.quoteOfTheDayURL
    
    init(
        healthService: HealthService,
        quoteService: QuoteService,
        quoteStorage: QuoteStorage
    ) {
        self.healthService = healthService
        self.quoteService = quoteService
        self.quoteStorage = quoteStorage
    }
    
    func loadHomeContent() async {
        isLoading = true
        
        async let quoteTask: Void = fetchQuoteOfTheDay()
        async let healthTask: Void = loadHealthDataIfAvailable()
        
        await quoteTask
        await healthTask
        
        isLoading = false
    }
    
    func fetchQuoteOfTheDay() async {
        do {
            let cachedQuote = try await quoteStorage.obtainQuoteOfTheDay()
            if let cachedQuote {
                self.quoteOfTheDay = cachedQuote
            } else {
                quoteOfTheDay = try await quoteService.fetchQuotes(for: quoteURL).first
                if let quoteOfTheDay {
                    try await quoteStorage.saveQuoteOfTheDay(quote: quoteOfTheDay)
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func requestAuthorization() async {
        isLoading = true
        
        do {
            try await healthService.requestAuthorization()
            await fetchHealthData()
        } catch {
            healthState = .unavailable
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    private func loadHealthDataIfAvailable() async {
        do {
            let shouldRequestAuthorization = try await healthService.shouldRequestAuthorization()
            guard !shouldRequestAuthorization else {
                healthState = .needsAuthorization
                return
            }
            
            await fetchHealthData()
        } catch {
            healthState = .unavailable
        }
    }
    
    private func fetchHealthData() async {
        do {
            async let stepsTask = healthService.fetchTodayStepCount()
            async let heartRateTask = healthService.fethcTodayHeartRate()
            
            let (steps, heartRate) = try await (stepsTask, heartRateTask)
            self.todaysSteps = steps
            self.recentHeartRate = heartRate
            healthState = steps == nil && heartRate == nil ? .unavailable : .content
        } catch {
            healthState = .unavailable
        }
    }
}

enum HealthViewState {
    case needsAuthorization
    case content
    case unavailable
}
