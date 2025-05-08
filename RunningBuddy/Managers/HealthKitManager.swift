//
//  HealthKitManager.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 07.05.25.
//

import SwiftUI
import HealthKit

class HealthKitManager {
    static var shared = HealthKitManager()
    var healthStore = HKHealthStore()
    
    let activityTypes: Set = [
        HKQuantityType.workoutType(),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.basalEnergyBurned),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.heartRate),
        HKSeriesType.workoutRoute(),
        HKSeriesType.workoutType(),
        HKSampleType.activitySummaryType()
    ]
    
    func ensuresHealthKitSetup()  {
        if HKHealthStore.isHealthDataAvailable() {
            print("health kit is available")
        } else {
            print("health kit is not available")
        }
    }
    
    func getNumericFromHealthKit(startDate: Date, endDate: Date, sample type: HKQuantityType, resultType: HKUnit) async -> Double? {
//        let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
//        let endDate = Date()

//        let calloriesType = HKQuantityType(.activeEnergyBurned)
        
        do {
            let data: Double = try await withCheckedThrowingContinuation { continuation in
                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
                let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate) { _, result, error in
                    if let error = error {
                        
                        continuation.resume(throwing: error)
                    } else {
                        let result = result?.sumQuantity()?.doubleValue(for: resultType) ?? -1.0
                        print("result numeric", result)
                        continuation.resume(returning: result)
                    }
                }
                healthStore.execute(query)
            }
            return data
            
        } catch let error {
            print(error)
            print("error fetching callories")
            return nil
        }
    }
    
}

