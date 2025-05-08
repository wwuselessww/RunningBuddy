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
    let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    let endDate = Date()
    
    
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
        guard let res = await healtKit.getNumericFromHealthKit(startDate: startDate, endDate: endDate, sample: HKQuantityType(.distanceWalkingRunning), resultType: .meterUnit(with: .kilo)) else {
            return
        }
        await MainActor.run {
            totalMonthDistance = res
        }
    }
    
    @MainActor
    private func getCallories() async {
            guard let res = await healtKit.getNumericFromHealthKit(startDate: startDate, endDate: endDate, sample: HKQuantityType(.activeEnergyBurned), resultType: .largeCalorie()) else {
                print("kek")
                return
            }
            
            await MainActor.run {
                currentActivity = Int(res)
                print("res res \(res)")
            }
    }
}
