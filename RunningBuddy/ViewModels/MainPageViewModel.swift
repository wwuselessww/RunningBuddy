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
    @Published var workModelArray: [HKWorkoutModel] = []
    @Published var didTapOnWorkout: Bool = false
    @Published var currentIndex: Int = 0
    
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
                print(error)
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
        guard let start = Calendar.current.date(byAdding: .day, value: -14, to: Date()) else {
            print("no start date?")
            return
        }
        let res = await healtKitManager.getWorkouts(from: start, to: endDate)
        var modelArray: [HKWorkoutModel] = []
        for i in res {
            let date = i.startDate
            guard  let distance = i.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo)), let pulse = await healtKitManager.getBPMFor(workout: i, type: .avg, options: .discreteAverage) else {
                print("no data")
                return
            }
            let newWorkout = HKWorkoutModel(workout: i, date: date, distance: distance, avgPulse: pulse, type: .outdoorRun)
            modelArray.append(newWorkout)
            
        }
        await MainActor.run {
            workoutArray = res
            workModelArray = modelArray
        }
    }
    
    
}
