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
    @Published var workoutArray: [HKWorkout] = []
    @Published var workModelArray: [WorkoutModel] = []
    var healtKitManager = HealthKitManager.shared
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
                    await self.getWorkouts()
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    @MainActor
    private func getSteps() async {
        guard let res = await healtKitManager.getNumericFromHealthKit(startDate: startDate, endDate: endDate, sample: HKQuantityType(.distanceWalkingRunning), resultType: .meterUnit(with: .kilo)) else {
            return
        }
        await MainActor.run {
            totalMonthDistance = res
        }
    }
    
    @MainActor
    private func getCallories() async {
            guard let res = await healtKitManager.getNumericFromHealthKit(startDate: startDate, endDate: endDate, sample: HKQuantityType(.activeEnergyBurned), resultType: .largeCalorie()) else {
                print("kek")
                return
            }
            
            await MainActor.run {
                currentActivity = Int(res)
                print("res res \(res)")
            }
    }
    
    @MainActor
    func getWorkouts() async {
        guard let start = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
            print("no start date?")
            return
        }
        let res = await healtKitManager.getWorkouts(startDate: start, endDate: endDate)
        let first = res.first?.statistics(for: HKQuantityType(.distanceWalkingRunning))
        var modelArray: [WorkoutModel] = []
        for i in res {
//            print("first \(first?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo)))")
            print(String(i.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo)) ?? 0))
            let date = i.startDate
            guard  let distance = i.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo)), let pulse = await healtKitManager.getAvgPulseFor(workout: i) else {
                print("no data")
                return
            }
            let newWorkout = WorkoutModel(workout: i, date: date, distance: distance, avgPulse: pulse, type: .outdoorRun)
            modelArray.append(newWorkout)
            
        }
        print(modelArray)
        await MainActor.run {
            workoutArray = res
            workModelArray = modelArray
        }
    }
    
    
}
