//
//  MockHealthService.swift
//  LaymiTests
//
//  Created by Ляйсан
//

@testable import Laymi

final class MockHealthService: HealthService {
    var requestAuthorizationError: Error?
    var stepsResult: Result<Double, Error>
    var heartRateResult: Result<Double?, Error>
    
    init(
        requestAuthorizationError: Error? = nil,
        stepsResult: Result<Double, Error> = .success(0),
        heartRateResult: Result<Double?, Error> = .success(nil)
    ) {
        self.requestAuthorizationError = requestAuthorizationError
        self.stepsResult = stepsResult
        self.heartRateResult = heartRateResult
    }
    
    func requestAuthorization() async throws {
        if let requestAuthorizationError {
            throw requestAuthorizationError
        }
    }
    
    func fetchTodayStepCount() async throws -> Double {
        try stepsResult.get()
    }
    
    func fethcTodayHeartRate() async throws -> Double? {
        try heartRateResult.get()
    }
}
