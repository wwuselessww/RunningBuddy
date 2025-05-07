//
//  MainPageViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 06.05.25.
//

import SwiftUI
import HealthKit

class MainPageViewModel: ObservableObject {
    @Published var totalMonthDistance: Double = 10
    @Published var maxActivity: Int = 1000
    @Published var currentActivity: Int = 0
    var healtKit = HealthKitManager.shared
    var store = HealthKitManager.shared.healthStore
    
    
    func getActivity() {
        let stepCounter = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let workoutType = HKObjectType.workoutType()
        store.requestAuthorization(toShare: [], read: [stepCounter, workoutType]) { isSuccess, error in
            if isSuccess {
                print("working")
                Task {
                    await self.getSteps()
                    await self.getCallories()
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    @MainActor
    private func getSteps() async {
        let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let endDate = Date()

        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return
        }
        
        do {
            let distance: Double = try await withCheckedThrowingContinuation { continuation in
                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
                let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        let distanceInKm = result?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo)) ?? -1.0
                        continuation.resume(returning: distanceInKm)
                    }
                }
                store.execute(query)
            }
            await MainActor.run {
                totalMonthDistance = distance
            }
            
        } catch {
            print("error fetching distance")
        }
    }
    
    @MainActor
    private func getCallories() async {
        let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let endDate = Date()

        let calloriesType = HKQuantityType(.activeEnergyBurned)
        
        do {
            let callories: Double = try await withCheckedThrowingContinuation { continuation in
                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
                let query = HKStatisticsQuery(quantityType: calloriesType, quantitySamplePredicate: predicate) { _, result, error in
                    if let error = error {
                        
                        continuation.resume(throwing: error)
                    } else {
                        let callories = result?.sumQuantity()?.doubleValue(for: .largeCalorie()) ?? -1.0
                        print("callories", callories)
                        continuation.resume(returning: callories)
                    }
                }
                store.execute(query)
            }
            await MainActor.run {
                currentActivity = Int(callories)
            }
        } catch let error {
            print(error)
            print("error fetching callories")
        }
    }
}
