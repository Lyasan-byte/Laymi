//
//  HealthService.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

protocol HealthService {
    func shouldRequestAuthorization() async throws -> Bool
    func requestAuthorization() async throws
    func fetchTodayStepCount() async throws -> Double?
    func fethcTodayHeartRate() async throws -> Double?
}
