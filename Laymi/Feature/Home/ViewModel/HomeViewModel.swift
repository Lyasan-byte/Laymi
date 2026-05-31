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
    
    private let hasRequestedHealthAccessKey = "hasRequestedHealthAccess"
    
    var isLoading = true
    var isHealthConnected = false
    var quoteOfTheDay: Quote?
    var todaysSteps: Double = 0
    var recentHeartRate: Double? = 0
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
        async let healthTask: Void = loadHealthDataIfNeeded()
        
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
        UserDefaults.standard.set(true, forKey: hasRequestedHealthAccessKey)
        
        do {
            try await healthService.requestAuthorization()
            await fetchHealthData()
        } catch {
            isHealthConnected = false
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    private func loadHealthDataIfNeeded() async {
        guard UserDefaults.standard.bool(forKey: hasRequestedHealthAccessKey) else {
            isHealthConnected = false
            return
        }
        
        await fetchHealthData()
    }
    
    private func fetchHealthData() async {
        do {
            async let stepsTask = healthService.fetchTodayStepCount()
            async let heartRateTask = healthService.fethcTodayHeartRate()
            
            let (steps, heartRate) = try await (stepsTask, heartRateTask)
            isHealthConnected = true
            self.todaysSteps = steps
            self.recentHeartRate = heartRate
        } catch {
            isHealthConnected = false
        }
    }
}
