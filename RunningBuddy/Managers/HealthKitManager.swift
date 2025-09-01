//
//  HealthKitManager.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 07.05.25.
//

import SwiftUI
import HealthKit
import CoreLocation

class HealthKitManager {
    static var shared = HealthKitManager()
    var healthStore = HKHealthStore()
    var isAuthorized: Bool = false
    let activityTypes: Set<HKSampleType> = [
        HKObjectType.workoutType(),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.basalEnergyBurned),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.heartRate),
        HKQuantityType(.stepCount),
        HKSeriesType.workoutRoute(),
//        HKActivitySummaryType.activitySummaryType()
    ]
    
    private init() {
        ensuresHealthKitSetup()
    }
    
    func ensuresHealthKitSetup() -> Bool  {
        if HKHealthStore.isHealthDataAvailable() {
            print("health kit is available")
            isAuthorized = true
            return true
        } else {
            print("health kit is not available")
            isAuthorized = false
            return false
        }
    }
    
    func getNumericFromHealthKit(startDate: Date, endDate: Date, sample type: HKQuantityType, resultType: HKUnit) async -> Double? {
        do {
            let data: Double = try await withCheckedThrowingContinuation { continuation in
                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
                let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate) { _, result, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        let result = result?.sumQuantity()?.doubleValue(for: resultType) ?? -1.0
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
    
    func getStepsForPeriod(startDate: Date, endData: Date, type: HKQuantityType, options: HKStatisticsOptions = [], interval: DateComponents, resultType: HKUnit) async -> [ChartModel] {
        let today = Calendar.current.startOfDay(for: Date())
        do {
            let data: [ChartModel] = try await withCheckedThrowingContinuation { continuation in
                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endData)
                let query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: options, anchorDate: today, intervalComponents: interval)
                query.initialResultsHandler = { _, results, error in
                    if let error = error {
                        print(error)
                        continuation.resume(throwing: error)
                    }
                    var count:  [ChartModel] = []
                    
                    results?.enumerateStatistics(from: startDate, to: endData) { stat, _ in
                        let date = stat.startDate
                        let unitToCount = stat.sumQuantity()?.doubleValue(for: resultType) ?? 0
                        count.append(ChartModel(date: date, number: Int(unitToCount)))
                        
                    }
                    continuation.resume(returning: count)
                    
                }
                self.healthStore.execute(query)
            }
            return data
        } catch {
            print("getNumericArray ,\(error)")
            return []
        }
    }
    
    func getWorkouts(from: Date, to: Date) async -> [HKWorkout] {
        let predicate = HKQuery.predicateForSamples(withStart: from, end: to)
        do {
            let data: [HKWorkout] = try await withCheckedThrowingContinuation { continuation in
                let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)]) { query, sample, error in
                    if let error = error {
                        print(error)
                        continuation.resume(throwing: error)
                    }
                    guard let samples = sample else {
                        fatalError("some error")
                    }
                    let workouts = samples.compactMap { $0 as? HKWorkout }
                    continuation.resume(returning: workouts)
                }
                healthStore.execute(query)
            }
            return data
        } catch {
            print(error)
            return []
        }
    }
        
    func getBPMFor(workout: HKWorkout, type: StatisticType, options: HKStatisticsOptions) async -> Int? {
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate)
        do {
            let rate: Double = try await withCheckedThrowingContinuation { continuation in
                let query = HKStatisticsQuery(quantityType: HKQuantityType(.heartRate), quantitySamplePredicate: predicate, options: options) { _, stats, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    switch type {
                    case .avg:
                        let bpm = stats?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())) ?? 0
                        continuation.resume(returning: bpm)
                    case .min:
                        let bpm = stats?.minimumQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())) ?? 0
                        continuation.resume(returning: bpm)
                    case .max:
                        let bpm = stats?.maximumQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())) ?? 0
                        continuation.resume(returning: bpm)
                    }
                }
                healthStore.execute(query)
            }
            return Int(rate)
        } catch {
            print("BPM ERROR \(error)")
            return nil
        }
    }
    
    func getPaceFor(workout: HKWorkout) async -> Double? {
        let durationInMinutes = workout.duration / 60
        guard let distance = workout.totalDistance?.doubleValue(for: .meter()) else {
            return nil
        }
        let distanceInKm = distance / 1000
        guard distanceInKm > 0 else {
            return nil
        }
        let pace = durationInMinutes / distanceInKm
        return pace
    }
    
    func getRouteFor(workout: HKWorkout) async -> [CLLocation]? {
        let predicate = HKQuery.predicateForObjects(from: workout)
        
        return try? await withCheckedThrowingContinuation { continuation in
            let sampleQuery = HKSampleQuery(
                sampleType: HKSeriesType.workoutRoute(),
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let route = samples?.first as? HKWorkoutRoute else {
                    continuation.resume(returning: [])
                    return
                }
                
                var allLocations: [CLLocation] = []
                
                let routeQuery = HKWorkoutRouteQuery(route: route) { _, locations, done, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    if let locations = locations {
                        allLocations.append(contentsOf: locations)
                    }
                    
                    if done {
                        continuation.resume(returning: allLocations)
                    }
                }
                
                self.healthStore.execute(routeQuery)
            }
            
            self.healthStore.execute(sampleQuery)
        }
    }
    
    func getHeartZonesFor(_ workout: HKWorkout) async -> [Split] {
        await withCheckedContinuation { continuation in
            var zonesArray: [Split] = [
                .init(splitNumber: 1, timeInSplit: 0, color: .blue),
                .init(splitNumber: 2, timeInSplit: 0, color: .green),
                .init(splitNumber: 3, timeInSplit: 0, color: .yellow),
                .init(splitNumber: 4, timeInSplit: 0, color: .orange),
                .init(splitNumber: 5, timeInSplit: 0, color: .red)
            ]
            var prevDateSample: Date?
            
            let predicate = HKQuery.predicateForObjects(from: workout)
            let query = HKSampleQuery(sampleType: HKQuantityType(.heartRate), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                
                guard error == nil else {
                    print(error?.localizedDescription ?? "Unknown error")
                    continuation.resume(returning: zonesArray) // return empty/default if failed
                    return
                }
                
                guard let zones = samples as? [HKQuantitySample] else {
                    continuation.resume(returning: zonesArray)
                    return
                }
                
                
                for sample in zones {
                    let res = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                    let duration = sample.endDate.timeIntervalSince(prevDateSample ?? sample.startDate)
                    prevDateSample = sample.endDate
                    
                    
                    switch res {
                    case 0..<134: zonesArray[0].timeInSplit += duration / 60
                    case 134..<148: zonesArray[1].timeInSplit += duration / 60
                    case 148..<162: zonesArray[2].timeInSplit += duration / 60
                    case 162..<176: zonesArray[3].timeInSplit += duration / 60
                    case 176..<300: zonesArray[4].timeInSplit += duration / 60
                    default:
                        print("NO ZONE??? \(res)")
                    }
                }
                continuation.resume(returning: zonesArray)
            }
            
            healthStore.execute(query)
        }
    }
}

