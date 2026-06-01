//
//  MockHealthService.swift
//  LaymiTests
//
//  Created by Ляйсан
//

@testable import Laymi

final class MockHealthService: HealthService {
    var shouldRequestAuthorizationResult: Result<Bool, Error>
    var requestAuthorizationError: Error?
    var stepsResult: Result<Double?, Error>
    var heartRateResult: Result<Double?, Error>
    
    init(
        shouldRequestAuthorizationResult: Result<Bool, Error> = .success(true),
        requestAuthorizationError: Error? = nil,
        stepsResult: Result<Double?, Error> = .success(nil),
        heartRateResult: Result<Double?, Error> = .success(nil)
    ) {
        self.shouldRequestAuthorizationResult = shouldRequestAuthorizationResult
        self.requestAuthorizationError = requestAuthorizationError
        self.stepsResult = stepsResult
        self.heartRateResult = heartRateResult
    }
    
    func shouldRequestAuthorization() async throws -> Bool {
        try shouldRequestAuthorizationResult.get()
    }
    
    func requestAuthorization() async throws {
        if let requestAuthorizationError {
            throw requestAuthorizationError
        }
    }
    
    func fetchTodayStepCount() async throws -> Double? {
        try stepsResult.get()
    }
    
    func fethcTodayHeartRate() async throws -> Double? {
        try heartRateResult.get()
    }
}
