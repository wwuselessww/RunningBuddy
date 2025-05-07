//
//  MainPageViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 06.05.25.
//

import SwiftUI
import HealthKit

class MainPageViewModel: ObservableObject {
    @Published var totalMonthDistance: Int = 10
    @Published var maxActivity: Int = 1000
    @Published var currentActivity: Int = 200
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
                    }
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
                totalMonthDistance = Int(distance)
            }
            
        } catch {
            print("error fetching distance")
        }
    }
}
