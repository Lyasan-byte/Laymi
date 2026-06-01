//
//  HealthKitService.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import HealthKit

final class HealthKitService: HealthService {
    private let healthStore = HKHealthStore()
    
    func shouldRequestAuthorization() async throws -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthKitError.healthDataUnavailable
        }
        
        let status = try await healthStore.statusForAuthorizationRequest(
            toShare: [],
            read: readTypes
        )
        
        switch status {
        case .shouldRequest:
            return true
        case .unnecessary:
            return false
        case .unknown:
            return true
        default:
            return true
        }
    }
    
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthKitError.healthDataUnavailable
        }
        
        try await healthStore.requestAuthorization(toShare: [], read: readTypes)
    }
    
    func fetchTodayStepCount() async throws -> Double? {
        let descriptor = fetchDescriptorForQuantityType(
            .stepCount,
            predicate: predicateForToday(),
            options: .cumulativeSum
        )
        
        let result = try await descriptor.result(for: healthStore)
        return result?.sumQuantity()?.doubleValue(for: .count())
    }
    
    func fethcTodayHeartRate() async throws -> Double? {
        let descriptor = fetchDescriptorForQuantityType(
            .heartRate,
            predicate: predicateForToday(),
            options: .mostRecent
        )
        
        let result = try await descriptor.result(for: healthStore)
        return result?.mostRecentQuantity()?.doubleValue(for: .count().unitDivided(by: .minute()))
    }
    
    private func fetchDescriptorForQuantityType(
        _ quantityType: HKQuantityTypeIdentifier,
        predicate: NSPredicate,
        options: HKStatisticsOptions) -> HKStatisticsQueryDescriptor {
        
        HKStatisticsQueryDescriptor(
            predicate: HKSamplePredicate<HKQuantitySample>.quantitySample(
                type: HKQuantityType(quantityType),
                predicate: predicate
            ),
            options: options
        )
    }
    
    private func predicateForToday() -> NSPredicate {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        return HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
    }
    
    private var readTypes: Set<HKObjectType> {
        [
            HKQuantityType(.stepCount),
            HKQuantityType(.heartRate)
        ]
    }
}

enum HealthKitError: LocalizedError {
    case healthDataUnavailable
    case noStepData
    case authorizationDenied

    var errorDescription: String? {
        switch self {
        case .healthDataUnavailable:
            return "Health data is not available on this device."
        case .noStepData:
            return "No step data is available for today."
        case .authorizationDenied:
            return "Health access was not granted."
        }
    }
}
