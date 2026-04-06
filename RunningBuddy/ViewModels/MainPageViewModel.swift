//
//  NewMainPageViewModel.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 29.01.26.
//

import SwiftUI
import HealthKit
import CoreLocation

@Observable class MainPageViewModel {
    var days: [Days] = [.init(name: "mon", number: 0),.init(name: "tue", number: 0),.init(name: "wen", number: 0),.init(name: "thu", number: 0),.init(name: "fri", number: 0),.init(name: "sat", number: 0),.init(name: "sun", number: 0)]
    
    var activityValue = 0.2
    var waterLevel = 0.7
    var isPressed : Bool = false
    var chosenDay: Int = 0
    var waterTitle: Int = 10
    var activityTitle: Int = 15
    var authenticated: Bool = false
    var trigger: Bool = false
    
    var maxCallories: Int = 1000
    var callories: Int = 0
    var hkWorkouts: [HKWorkoutModel] = []
    var didTapOnWorkout: Bool = false
    
    var healtKitManager = HealthKitManager.shared
    private  var store = HealthKitManager.shared.healthStore
    private let startOfTheDay = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    private let currentTime = Date()
    private let workoutProvider: WorkoutProvider
    private var startOfTheWeek: Date  {
        return calendar.startOfWeek(for: Date.now) ?? Date.now
    }
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        calendar.locale = Locale(identifier: "en_GB")
        calendar.timeZone = .current
        return calendar
    }
    
    var chosenDateStart: Date = Calendar.current.startOfDay(for: Date.now).startOfDay
    var chosenDateEnd: Date = Calendar.current.startOfDay(for: Date.now).endOfDay
    
    init(workoutProvider: WorkoutProvider = WorkoutProvider.shared) {
        self.workoutProvider = workoutProvider
        setSelectorToToday()
        setWeekArray()
    }
    
    public func setDateTo(_ date: Int) {
        guard let startOfTheMonth = calendar.startOfMonth(for: Date.now) else {
            print("error with startOfTheMonth")
            return
        }
        let adjustedDate = date - 1
        let selectedDate = calendar.date(byAdding: .day, value: adjustedDate, to: startOfTheMonth) ?? Date.now
        chosenDateStart = selectedDate.startOfDay
        chosenDateEnd = selectedDate.endOfDay
    }
    
    public func updateView() {
        Task {
            activityTitle = await fetchCalories(from: chosenDateEnd, untill: chosenDateStart)
            let appleWorkouts = await fetchHKWorkouts()
            let convertedAppleWorkouts = await convertHKWorkoutsToHKWorkoutModels(appleWorkouts)
            await MainActor.run {
                withAnimation {
                    activityValue = calculateCalooriesRing()
                    hkWorkouts = convertedAppleWorkouts
                }
            }
        }
    }
    
    private func fetchHKWorkouts() async -> [HKWorkout] {
        var workouts: [HKWorkout] = []
        workouts = await healtKitManager.getWorkouts(from: chosenDateStart, to: chosenDateEnd)
        return workouts
    }
    
    private func fetchCalories(from date: Date, untill endDate: Date) async -> Int{
        guard let callories = await healtKitManager.getNumericFromHealthKit(startDate: chosenDateStart.startOfDay, endDate: chosenDateEnd.endOfDay, sample: HKQuantityType(.activeEnergyBurned), resultType: .largeCalorie()) else {
            print("no callories for today")
            return 0
        }
        return Int(callories)
    }
    
    private func calculateCalooriesRing() -> Double {
        let maxCalories = Double(maxCallories)
        return Double(activityTitle) / maxCalories 
    }
    
    private func convertHKWorkoutsToHKWorkoutModels(_ workouts: [HKWorkout]) async -> [HKWorkoutModel] {
        var result: [HKWorkoutModel] = []
        for workout in workouts {
            guard  let distance = workout.statistics(for: HKQuantityType(.distanceWalkingRunning))?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo)) else {
                print("no distance")
                continue
            }
            let pulse = await healtKitManager.getBPMFor(workout: workout, type: .avg, options: .discreteAverage)
            let coordinates = await healtKitManager.getRouteFor(workout: workout)
            let convertedTo2D = coordinates?.map { CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)}
            
            result.append(.init(id: workout.uuid,
                                workout: workout,
                                date: workout.endDate,
                                distance: distance,
                                avgPulse: pulse ?? 0,
                                type: workout.workoutActivityType == .running ? .outdoorRun : .outdoorWalk,
                                path: convertedTo2D,
                                duration: nil,
                                pace: nil,
                                recordedByPhone: false
                               ))
        }
        
        return result
    }
    
    
    private func createPathfromCoordinates(latitudes: [Double], longitudes: [Double]) -> [CLLocationCoordinate2D] {
        let size = latitudes.count
        var path = [CLLocationCoordinate2D]()
        for i in 0..<size {
            path.append(.init(latitude: latitudes[i], longitude: longitudes[i]))
        }
        
        return path
    }
    
    private func setSelectorToToday() {
        chosenDay = calendar.component(.day, from: Date.now)
    }
    
    private func setWeekArray() {
        let startOfTheWeek = calendar.startOfWeek(for: Date.now)!
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: i, to: startOfTheWeek)!
            days[i].number = calendar.component(.day, from: date)
        }
    }
    
    
    func debug(_ date: Date, calendar: Calendar) {
        print("debug".capitalized)
        print("weekday:", calendar.component(.weekday, from: date)) // 2 = Monday
        print("local:", date.formatted(date: .complete, time: .complete))
        print("UTC:", date)
    }
}
