//
//  MainPageViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 06.05.25.
//

import SwiftUI
import HealthKit
import CoreLocation

@MainActor
class MainPageViewModel: ObservableObject {
    @Published var totalMonthDistance: Double = 0
    @Published var maxActivity: Int = 1000
    @Published var currentActivity: Int = 0
    @Published var workoutArray: [HKWorkout] = []
    @Published var workModelArray: [HKWorkoutModel] = []
    @Published var didTapOnWorkout: Bool = false
    @Published var currentIndex: Int = 0
    
    @Published var phoneRecordedWorkouts: [Workout] = []
    
    var healtKitManager = HealthKitManager.shared
    private  var store = HealthKitManager.shared.healthStore
    private let startOfTheDay = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    private let currentTime = Date()
    
    private let startOfTheMonth: Date = {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date.now)
        let result = calendar.date(from: components)
        return result ?? Date.now
    }()
    
    
    
    
    
    
    @MainActor
    func getActivity() {
        let stepCounter = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let workoutType = HKObjectType.workoutType()
        store.requestAuthorization(toShare: [], read: [stepCounter, workoutType]) { isSuccess, error in
            if isSuccess {
                Task {
                    await self.getCallories()
                    await self.getWorkouts()
                    await self.createWorkoutsArray()
                    await self.getDistanceForCurrentMonth()
                }
                
            } else {
                print(error!)
            }
        }
    }
    @MainActor
    func createWorkoutsArray() async {
        var tempArray: [HKWorkoutModel] = []
        for workout in phoneRecordedWorkouts {
            var path: [CLLocationCoordinate2D] = []
            if let latitudes = workout.latitudes, let longitudes = workout.longitudes {
                var tempPath: CLLocationCoordinate2D
                for cordIndex in 0..<latitudes.count {
                    tempPath = .init(latitude: latitudes[cordIndex], longitude: longitudes[cordIndex])
                    path.append(tempPath)
                }
            } else {
                print("no data coordinates")
            }
            print("path \(path)")
            let workoutModel: HKWorkoutModel = .init(
                workout: nil,
                date: workout.creationDate,
                distance: workout.distance,
                avgPulse: nil,
                type: .outdoorRun,
                path: path,
                duration: Int(workout.duration),
                pace: workout.pace,
                recordedByPhone: true
            )
            tempArray.append(workoutModel)
        }
        await MainActor.run {
            workModelArray += tempArray
            workModelArray.sort { $0.date > $1.date }
        }
        
    }
    
    @MainActor
    private func getDistanceForCurrentMonth() async {
        var tempDistance: Double = 0
        for workout in workModelArray {
            tempDistance += workout.distance
        }
        
//        await MainActor.run {
            totalMonthDistance = tempDistance
//        }
    }
    
    @MainActor
    private func getCallories() async {
        guard let res = await healtKitManager.getNumericFromHealthKit(startDate: startOfTheDay, endDate: currentTime, sample: HKQuantityType(.activeEnergyBurned), resultType: .largeCalorie()) else {
            return
        }
        
//        await MainActor.run {
            currentActivity = Int(res)
//        }
    }
    
    @MainActor
    func getWorkouts() async {
        let res = await healtKitManager.getWorkouts(from: startOfTheMonth, to: currentTime)
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
